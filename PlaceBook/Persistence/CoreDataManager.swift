//
//  CoreDataManager.swift
//  PlaceBook
//
//  Created by Ahmet CILINGIR on 18.09.26.
//

import CoreData

final class CoreDataManager {

    static let shared = CoreDataManager()

    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "PlaceBook")

        container.loadPersistentStores { _, error in
            if let error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }

        return container
    }()

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    func saveContext() {

        guard context.hasChanges else { return }

        do {
            try context.save()
        } catch {
            print("Core Data save error: \(error.localizedDescription)")
        }
    }

    func addPlace(
        name: String,
        category: String,
        notes: String?,
        latitude: Double,
        longitude: Double,
        imageData: Data?,
        isFavorite: Bool
    ) {
        let place = PlaceEntity(context: context)

        place.id = UUID()
        place.name = name
        place.category = category
        place.note = notes
        place.latitude = latitude
        place.longitude = longitude
        place.isFavorite = isFavorite
        place.createdAt = Date()

        if let imageData {
            let photo = PhotoEntity(context: context)

            photo.id = UUID()
            photo.imageData = imageData
            photo.order = 0
            photo.place = place
        }

        saveContext()
    }

}
