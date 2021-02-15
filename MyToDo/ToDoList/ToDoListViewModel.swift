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

    private let storage: Storage

    init(storage: Storage = CoreDataStorage.shared) {
        self.storage = storage
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSManagedObjectContext.didSaveObjectsNotification, object: nil)
    }

    @objc func refresh() {
        todos = storage.getToDos()
    }

    func delete(indexSet: IndexSet) {
        indexSet.forEach {
            storage.delete(object: todos[$0])
        }
        todos.remove(atOffsets: indexSet)
    }
}
