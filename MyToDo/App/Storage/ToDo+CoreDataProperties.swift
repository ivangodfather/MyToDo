//
//  ToDo+CoreDataProperties.swift
//  MyToDo
//
//  Created by Ivan Ruiz Monjo on 20/2/21.
//
//

import Foundation
import CoreData


extension ToDo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDo> {
        return NSFetchRequest<ToDo>(entityName: "ToDo")
    }

    @NSManaged public var dueDate: Date
    @NSManaged public var title: String
    @NSManaged public var category: Category?
    @NSManaged public var priority: Priority
    @NSManaged public var attachments: Set<Attachment>?

}

extension ToDo : Identifiable {

}
