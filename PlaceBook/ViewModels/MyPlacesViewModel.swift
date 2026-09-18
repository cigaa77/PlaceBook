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

    func fetchPlaces() {

        let context = CoreDataManager.shared.context

        let request: NSFetchRequest<PlaceEntity> = PlaceEntity.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "createdAt", ascending: false)
        ]

        do {
            places = try context.fetch(request)
        } catch {
            print("Failed to fetch places: \(error.localizedDescription)")
        }
    }

    var numberOfPlaces: Int {
        places.count
    }

    func place(at index: Int) -> PlaceEntity {
        places[index]
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

}
