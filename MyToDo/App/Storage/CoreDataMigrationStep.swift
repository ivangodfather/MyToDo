//
//  CoreDataMigrationStep.swift
//  MyToDo
//
//  Created by Ivan Ruiz Monjo on 14/3/21.
//

import CoreData

struct CoreDataMigrationStep {
	let sourceModel: NSManagedObjectModel
	let destModel: NSManagedObjectModel
	let mappingModel: NSMappingModel

	init(source: CoreDataMigrationVersion, dest: CoreDataMigrationVersion) {
		sourceModel = NSManagedObjectModel.managedObjectModel(forResource: source.rawValue)
		destModel = NSManagedObjectModel.managedObjectModel(forResource: dest.rawValue)
		mappingModel = CoreDataMigrationStep.mappingModel(fromSourceModel: sourceModel, toDestinationModel: destModel)!
	}

	private static func mappingModel(fromSourceModel sourceModel: NSManagedObjectModel, toDestinationModel destinationModel: NSManagedObjectModel) -> NSMappingModel? {
		guard let customMapping = customMappingModel(fromSourceModel: sourceModel, toDestinationModel: destinationModel) else {
			return inferredMappingModel(fromSourceModel:sourceModel, toDestinationModel: destinationModel)
		}

		return customMapping
	}

	private static func inferredMappingModel(fromSourceModel sourceModel: NSManagedObjectModel, toDestinationModel destinationModel: NSManagedObjectModel) -> NSMappingModel? {
		return try? NSMappingModel.inferredMappingModel(forSourceModel: sourceModel, destinationModel: destinationModel)
	}

	private static func customMappingModel(fromSourceModel sourceModel: NSManagedObjectModel, toDestinationModel destinationModel: NSManagedObjectModel) -> NSMappingModel? {
		return NSMappingModel(from: [Bundle.main], forSourceModel: sourceModel, destinationModel: destinationModel)
	}
}

extension NSManagedObjectModel {

	// MARK: - Resource

	static func managedObjectModel(forResource resource: String) -> NSManagedObjectModel {
		let mainBundle = Bundle.main
		let subdirectory = "CoreDataStorage"

		var omoURL: URL?
		if #available(iOS 11, *) {
			omoURL = mainBundle.url(forResource: resource, withExtension: "omo", subdirectory: subdirectory) // optimized model file
		}
		let momURL = mainBundle.url(forResource: resource, withExtension: "mom", subdirectory: subdirectory)

		guard let url = omoURL ?? momURL else {
			fatalError("unable to find model in bundle")
		}

		guard let model = NSManagedObjectModel(contentsOf: url) else {
			fatalError("unable to load model in bundle")
		}

		return model
	}
}
