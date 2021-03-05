//
//  CoreDataStorage+ToDo.swift
//  MyToDo
//
//  Created by Ivan Ruiz Monjo on 18/2/21.
//

import Foundation

extension CoreDataStorage {

	func addToDo(title: String, dueDate: Date, category: Category, user: String, notes: String) -> ToDo {
        let todo = ToDo(context: viewContext)
        todo.title = title
        todo.dueDate = dueDate
        todo.category = category
		todo.user = user
		todo.notes = notes
		let priotiry = Priority(context: viewContext)
		priotiry.value = 1
		todo.priority = priotiry
        save()
        return todo
    }
}
