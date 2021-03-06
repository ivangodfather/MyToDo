//
//  Priority+.swift
//  MyToDo
//
//  Created by Ivan Ruiz Monjo on 6/3/21.
//

import CoreData

extension Priority {
	static func getPriority(from value: Int, usingContext context: NSManagedObjectContext) -> Priority {
		let request: NSFetchRequest<Priority> = Priority.fetchRequest()
		request.predicate = NSPredicate(format: "value == %d", value)
		let priority = try? context.fetch(request)
		if let priority = priority?.first {
			return priority
		} else {
			let new = Priority(context: context)
			new.value = Int64(value)
			switch value {
			case 0: new.title = "low"
			case 1: new.title  = "med"
			default: new.title = "high"
			}
			return new
		}
	}
}
