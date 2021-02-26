//
//  Priority+CoreDataProperties.swift
//  MyToDo
//
//  Created by Ivan Ruiz Monjo on 26/2/21.
//
//

import Foundation
import CoreData


extension Priority {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Priority> {
        return NSFetchRequest<Priority>(entityName: "Priority")
    }

    @NSManaged public var title: String?
    @NSManaged public var value: Int64
    @NSManaged public var todo: NSSet?

}

// MARK: Generated accessors for todo
extension Priority {

    @objc(addTodoObject:)
    @NSManaged public func addToTodo(_ value: ToDo)

    @objc(removeTodoObject:)
    @NSManaged public func removeFromTodo(_ value: ToDo)

    @objc(addTodo:)
    @NSManaged public func addToTodo(_ values: NSSet)

    @objc(removeTodo:)
    @NSManaged public func removeFromTodo(_ values: NSSet)

}

extension Priority : Identifiable {

}
