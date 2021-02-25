//
//  ToDo+.swift
//  MyToDo
//
//  Created by Ivan Ruiz Monjo on 22/2/21.
//

import Foundation

extension ToDo {
    static func random() -> ToDo {
        let context = CoreDataStorage.shared.viewContext
        let todo = ToDo(context: context)
        todo.title = "Random ToDo"
        let category = Category(context: context)
        category.title = "Grocery shop"
        todo.category = category
        todo.dueDate = Date()
        return todo
    }
}
