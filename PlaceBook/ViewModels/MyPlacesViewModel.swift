//
//  MyPlacesViewModel.swift
//  PlaceBook
//
//  Created by Ahmet CILINGIR on 18.09.26.
//

import CoreData
import Foundation
import UIKit

final class MyPlacesViewModel {

    private(set) var places: [PlaceEntity] = []
    private(set) var filteredPlaces: [PlaceEntity] = []
    private var currentFilter = "All"

    func fetchPlaces() {

        let context = CoreDataManager.shared.context

        let request: NSFetchRequest<PlaceEntity> = PlaceEntity.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "createdAt", ascending: false)
        ]

        do {
            places = try context.fetch(request)
            filteredPlaces = places
        } catch {
            print("Failed to fetch places: \(error.localizedDescription)")
        }
    }

    func filterPlaces(by filter: String) {

        currentFilter = filter

        switch filter {
        case "All":
            filteredPlaces = places
        case "Favorites":
            filteredPlaces = places.filter({ PlaceEntity in
                PlaceEntity.isFavorite
            })
        default:
            filteredPlaces = places.filter {
                $0.category == filter
            }
        }
    }

    var numberOfPlaces: Int {
        filteredPlaces.count
    }

    func place(at index: Int) -> PlaceEntity {
        filteredPlaces[index]
    }

    func coverImage(for place: PlaceEntity) -> UIImage? {

        guard let photos = place.photos as? Set<PhotoEntity> else { return nil }

        let sortedPhotos = photos.sorted {
            $0.order < $1.order
        }

        guard let firstPhoto = sortedPhotos.first,
            let imageData = firstPhoto.imageData
        else { return nil }

        return UIImage(data: imageData)
    }

    func toogleFavorite(at index: Int) {
        let place = filteredPlaces[index]
        place.isFavorite.toggle()

        filterPlaces(by: currentFilter)

        CoreDataManager.shared.saveContext()
    }

}
