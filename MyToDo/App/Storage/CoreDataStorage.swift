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
	let migrator = CoreDataMigrator()

    let persistentContainer: NSPersistentContainer
    var viewContext: NSManagedObjectContext { persistentContainer.viewContext }

    init() {
        persistentContainer = NSPersistentContainer(name: String(describing: CoreDataStorage.self))
		let description = persistentContainer.persistentStoreDescriptions.first
		description?.shouldInferMappingModelAutomatically = false //inferred mapping will be handled else where
		description?.shouldMigrateStoreAutomatically = false
		viewContext.automaticallyMergesChangesFromParent = false
		
    }

	func setup(completion: @escaping () -> Void) {
		 loadPersistentStore {
			 completion()
		 }
	 }

	private func loadPersistentStore(completion: @escaping () -> Void) {
		migrateStoreIfNeeded {
			self.persistentContainer.loadPersistentStores { description, error in
				guard error == nil else {
					fatalError("was unable to load store \(error!)")
				}

				completion()
			}
		}
	}

	private func migrateStoreIfNeeded(completion: @escaping () -> Void) {
		guard let storeURL = persistentContainer.persistentStoreDescriptions.first?.url else {
			fatalError("persistentContainer was not set up properly")
		}

		if migrator.requiresMigration(at: storeURL, toVersion: CoreDataMigrationVersion.current) {
			DispatchQueue.global(qos: .userInitiated).async {
				self.migrator.migrateStore(at: storeURL, toVersion: CoreDataMigrationVersion.current)

				DispatchQueue.main.async {
					completion()
				}
			}
		} else {
			completion()
		}
	}

	func items<T: NSManagedObject>(entity: T.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, context: NSManagedObjectContext? = nil) -> Result<[T], Error> {
        let entityName = String(describing: entity)
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        do {
            let fetchResults = try (context ?? viewContext).fetch(fetchRequest)
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

	func deleteAll() {
		let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "ToDo")
		let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

		do {
			try viewContext.execute(deleteRequest)
			NotificationCenter.default.post(name: NSManagedObjectContext.didSaveObjectsNotification, object: nil, userInfo:nil)
		} catch let error as NSError {
			print(error)
		}
	}
}
