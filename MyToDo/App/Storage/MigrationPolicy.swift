//
//  MigrationPolicy.swift
//  MyToDo
//
//  Created by Ivan Ruiz Monjo on 26/2/21.
//

import Foundation
import CoreData

class V2ToDoPolicy: NSEntityMigrationPolicy {

    var prioritys = [Int: NSManagedObject]()
    enum PriortyTitle: Int {
        case low = 0
        case medium
        case high

        var title: String {
            switch self {
            case .low: return "low"
            case .medium: return "medium"
            case .high: return "high"
            }
        }
    }

    override func createDestinationInstances(forSource sInstance: NSManagedObject, in mapping: NSEntityMapping, manager: NSMigrationManager) throws {
        let destinatinoTodo = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: manager.destinationContext)
        let keys = destinatinoTodo.entity.attributesByName.keys
        for key in keys {
            guard sInstance.entity.attributesByName.keys.contains(key) else {
                continue
            }
            if let value = sInstance.value(forKey: key) {
                destinatinoTodo.setValue(value, forKey: key)
            }
        }
        guard let originalPriority = sInstance.value(forKey: "priority") as? Int else {
            return
        }
        if let priority = prioritys[originalPriority] {
            destinatinoTodo.setValue(priority, forKey: "priority")
        } else {
            let priority = NSEntityDescription.insertNewObject(forEntityName: "Priority", into: manager.destinationContext)
            priority.setValue(originalPriority, forKey: "value")
            let title = PriortyTitle(rawValue: originalPriority)!.title
            priority.setValue(title, forKey: "title")
            prioritys[originalPriority] = priority
            destinatinoTodo.setValue(priority, forKey: "priority")
        }
        manager.associate(sourceInstance: sInstance, withDestinationInstance: destinatinoTodo, for: mapping)
    }
}
