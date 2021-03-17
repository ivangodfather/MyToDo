//
//  CoreDataMigrationVersion.swift
//  MyToDo
//
//  Created by Ivan Ruiz Monjo on 14/3/21.
//

import Foundation

enum CoreDataMigrationVersion: String, CaseIterable {
	case version1 = "Model"
	case version2 = "Model 2"
	case version3 = "Model 3"
	case version4 = "Model 4"

	static var current: CoreDataMigrationVersion {
		return allCases.last!
	}

	func nextVersion() -> CoreDataMigrationVersion? {
		switch self {
		case .version1: return .version2
		case .version2: return .version3
		case .version3: return .version4
		default: return nil
		}
	}
}
