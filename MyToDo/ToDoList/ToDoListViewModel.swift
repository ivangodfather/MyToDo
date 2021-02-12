//
//  ToDoListViewModel.swift
//  MyToDo
//
//  Created by Ivan Ruiz Monjo on 12/2/21.
//

import Foundation

final class ToDoListViewModel: ObservableObject {
    @Published var todos = [ToDo]()

    private let storage: Storage

    init(storage: Storage = CoreDataStorage.shared) {
        self.storage = storage
        refresh()
    }

    func refresh() {
        todos = storage.getToDos()
    }
}
