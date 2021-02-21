//
//  ToDoListViewModel.swift
//  MyToDo
//
//  Created by Ivan Ruiz Monjo on 12/2/21.
//

import Foundation
import CoreData

final class ToDoListViewModel: ObservableObject {

    @Published var todos = [ToDo]()
    private let storage: CoreDataStorage

    init(storage: CoreDataStorage = CoreDataStorage.shared) {
        self.storage = storage
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSManagedObjectContext.didSaveObjectsNotification, object: nil)
    }

    @objc func refresh() {
        if case Result<[ToDo], Error>.success(let todos) = storage.items() {
            self.todos = todos
        }
    }

    func delete(indexSet: IndexSet) {
        indexSet.forEach {
            storage.delete(todos[$0])
        }
        todos.remove(atOffsets: indexSet)
    }

    func didSearch(_ text: String) {
        guard !text.isEmpty else {
            refresh()
            return
        }
        let predicate1 = NSPredicate(format: "title CONTAINS[cd] %@", text)
        let predicate2 = NSPredicate(format: "category.title CONTAINS[cd] %@", text)
        let orPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [predicate1, predicate2])
        let items: Result<[ToDo], Error> = storage.items(predicate: orPredicate, sortDescriptors: nil)
        todos = (try? items.get()) ?? []

    }
}
