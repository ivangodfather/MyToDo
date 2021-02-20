//
//  Category+CoreDataProperties.swift
//  MyToDo
//
//  Created by Ivan Ruiz Monjo on 20/2/21.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var imageName: String?
    @NSManaged public var title: String
    @NSManaged public var todos: NSSet?

}

// MARK: Generated accessors for todos
extension Category {

    @objc(addTodosObject:)
    @NSManaged public func addToTodos(_ value: ToDo)

    @objc(removeTodosObject:)
    @NSManaged public func removeFromTodos(_ value: ToDo)

    @objc(addTodos:)
    @NSManaged public func addToTodos(_ values: NSSet)

    @objc(removeTodos:)
    @NSManaged public func removeFromTodos(_ values: NSSet)

}

extension Category : Identifiable {

}
