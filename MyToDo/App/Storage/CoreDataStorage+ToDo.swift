//
//  CoreDataStorage+ToDo.swift
//  MyToDo
//
//  Created by Ivan Ruiz Monjo on 18/2/21.
//

import Foundation

extension CoreDataStorage {

	func addToDo(title: String, dueDate: Date, category: Category, priorty: Int) -> ToDo {
        let todo = ToDo(context: viewContext)
        todo.title = title
        todo.dueDate = dueDate
        todo.category = category
		let prio = Priority.getPriority(from: priorty, usingContext: CoreDataStorage.shared.viewContext)
		todo.priority = prio
        save()
        return todo
    }
}
