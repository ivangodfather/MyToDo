//
//  CoreDataStorage.swift
//  MyToDo
//
//  Created by Ivan Ruiz Monjo on 12/2/21.
//

import CoreData

enum CoreDataError: Error {
    case unknown
}

final class CoreDataStorage {

    static let shared = CoreDataStorage()
    private let persistentContainer: NSPersistentContainer
    var viewContext: NSManagedObjectContext { persistentContainer.viewContext }

    init() {
        persistentContainer = NSPersistentContainer(name: String(describing: CoreDataStorage.self))
        persistentContainer.loadPersistentStores { persistentStoreDescription, error in
            guard error == nil else {
                fatalError("Uneable to load. \(error?.localizedDescription ?? "")")
            }
        }
    }

    func items<T: NSManagedObject>(entity: T.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> Result<[T], Error> {
        let entityName = String(describing: entity)
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
//        let fetchRequest = T.fetchRequest() this does not work lol?
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        do {
            let fetchResults = try viewContext.fetch(fetchRequest)
            return .success(fetchResults)
        } catch {
            return .failure(error)
        }
    }

    @discardableResult
    func delete<T: NSManagedObject>(_ entity: T) -> Result<Bool, Error> {
        viewContext.delete(entity)
        return .success(true)
    }


    func save() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print("Uneable to save viewContext. \(error.localizedDescription)")
            }
        }
    }
}
