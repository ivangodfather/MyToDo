//
//  Storage.swift
//  MyToDo
//
//  Created by Ivan Ruiz Monjo on 12/2/21.
//

import Foundation

protocol Storage {
    func save()
    func delete(object: Any)
    func getToDos() -> [ToDo]
    func addToDo(title: String, dueDate: Date, category: Category) -> ToDo
    func deleteToDos(indexSet: IndexSet)
    func getCategories() -> [Category]
    func addCategory(title: String, imageName: String) -> Category
}
