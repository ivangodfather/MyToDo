//
//  Attachment+CoreDataProperties.swift
//  MyToDo
//
//  Created by Ivan Ruiz Monjo on 28/2/21.
//
//

import Foundation
import CoreData

public class Attachment: NSManagedObject {

}

extension Attachment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Attachment> {
        return NSFetchRequest<Attachment>(entityName: "Attachment")
    }

    @NSManaged public var image: Data?
    @NSManaged public var todo: ToDo?

}

extension Attachment : Identifiable {

}
