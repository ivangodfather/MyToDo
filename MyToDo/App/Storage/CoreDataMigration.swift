//
//  CoreDataMigration.swift
//  MyToDo
//
//  Created by Ivan Ruiz Monjo on 14/3/21.
//

import CoreData

class CoreDataMigrator {

	func requiresMigration(at storeURL: URL, toVersion version: CoreDataMigrationVersion) -> Bool {
		guard let metadata = NSPersistentStoreCoordinator.metadata(at: storeURL) else {
			return false
		}

		return (CoreDataMigrationVersion.compatibleVersionForStoreMetadata(metadata) != version)
	}


	func migrateStore(at storeURL: URL, toVersion version: CoreDataMigrationVersion) {
	 forceWALCheckpointingForStore(at: storeURL)

	 var currentURL = storeURL
	 let migrationSteps = self.migrationStepsForStore(at: storeURL, toVersion: version)

	 for migrationStep in migrationSteps {
		 let manager = NSMigrationManager(sourceModel: migrationStep.sourceModel, destinationModel: migrationStep.destModel)
		 let destinationURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true).appendingPathComponent(UUID().uuidString)

		 do {
			 try manager.migrateStore(from: currentURL, sourceType: NSSQLiteStoreType, options: nil, with: migrationStep.mappingModel, toDestinationURL: destinationURL, destinationType: NSSQLiteStoreType, destinationOptions: nil)
		 } catch let error {
			 fatalError("failed attempting to migrate from \(migrationStep.sourceModel) to \(migrationStep.destModel), error: \(error)")
		 }

		 if currentURL != storeURL {
			 //Destroy intermediate step's store
			 NSPersistentStoreCoordinator.destroyStore(at: currentURL)
		 }

		 currentURL = destinationURL
	 }

	 NSPersistentStoreCoordinator.replaceStore(at: storeURL, withStoreAt: currentURL)

	 if (currentURL != storeURL) {
		 NSPersistentStoreCoordinator.destroyStore(at: currentURL)
	 }
 }

 private func migrationStepsForStore(at storeURL: URL, toVersion destinationVersion: CoreDataMigrationVersion) -> [CoreDataMigrationStep] {
	 guard let metadata = NSPersistentStoreCoordinator.metadata(at: storeURL), let sourceVersion = CoreDataMigrationVersion.compatibleVersionForStoreMetadata(metadata) else {
		 fatalError("unknown store version at URL \(storeURL)")
	 }

	 return migrationSteps(fromSourceVersion: sourceVersion, toDestinationVersion: destinationVersion)
 }

 private func migrationSteps(fromSourceVersion sourceVersion: CoreDataMigrationVersion, toDestinationVersion destinationVersion: CoreDataMigrationVersion) -> [CoreDataMigrationStep] {
	 var sourceVersion = sourceVersion
	 var migrationSteps = [CoreDataMigrationStep]()

	 while sourceVersion != destinationVersion, let nextVersion = sourceVersion.nextVersion() {
		let migrationStep = CoreDataMigrationStep(source: sourceVersion, dest: nextVersion)
		 migrationSteps.append(migrationStep)

		 sourceVersion = nextVersion
	 }

	 return migrationSteps
 }

 // MARK: - WAL

	func forceWALCheckpointingForStore(at storeURL: URL) {
		guard let metadata = NSPersistentStoreCoordinator.metadata(at: storeURL), let currentModel = NSManagedObjectModel.compatibleModelForStoreMetadata(metadata) else {
			return
		}

	 do {
		 let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: currentModel)

		 let options = [NSSQLitePragmasOption: ["journal_mode": "DELETE"]]
		 let store = persistentStoreCoordinator.addPersistentStore(at: storeURL, options: options)
		 try persistentStoreCoordinator.remove(store)
	 } catch let error {
		 fatalError("failed to force WAL checkpointing, error: \(error)")
	 }
 }

}

private extension CoreDataMigrationVersion {

	// MARK: - Compatible

	static func compatibleVersionForStoreMetadata(_ metadata: [String : Any]) -> CoreDataMigrationVersion? {
		let compatibleVersion = CoreDataMigrationVersion.allCases.first {
			let model = NSManagedObjectModel.managedObjectModel(forResource: $0.rawValue)

			return model.isConfiguration(withName: nil, compatibleWithStoreMetadata: metadata)
		}

		return compatibleVersion
	}
}

extension NSPersistentStoreCoordinator {

	// MARK: - Destroy

	static func destroyStore(at storeURL: URL) {
		do {
			let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: NSManagedObjectModel())
			try persistentStoreCoordinator.destroyPersistentStore(at: storeURL, ofType: NSSQLiteStoreType, options: nil)
		} catch let error {
			fatalError("failed to destroy persistent store at \(storeURL), error: \(error)")
		}
	}

	// MARK: - Replace

	static func replaceStore(at targetURL: URL, withStoreAt sourceURL: URL) {
		do {
			let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: NSManagedObjectModel())
			try persistentStoreCoordinator.replacePersistentStore(at: targetURL, destinationOptions: nil, withPersistentStoreFrom: sourceURL, sourceOptions: nil, ofType: NSSQLiteStoreType)
		} catch let error {
			fatalError("failed to replace persistent store at \(targetURL) with \(sourceURL), error: \(error)")
		}
	}

	// MARK: - Meta

	static func metadata(at storeURL: URL) -> [String : Any]?  {
		return try? NSPersistentStoreCoordinator.metadataForPersistentStore(ofType: NSSQLiteStoreType, at: storeURL, options: nil)
	}

	// MARK: - Add

	func addPersistentStore(at storeURL: URL, options: [AnyHashable : Any]) -> NSPersistentStore {
		do {
			return try addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: options)
		} catch let error {
			fatalError("failed to add persistent store to coordinator, error: \(error)")
		}
	}
}

extension NSManagedObjectModel {

	// MARK: - Compatible

	static func compatibleModelForStoreMetadata(_ metadata: [String : Any]) -> NSManagedObjectModel? {
		let mainBundle = Bundle.main
		return NSManagedObjectModel.mergedModel(from: [mainBundle], forStoreMetadata: metadata)
	}
}
