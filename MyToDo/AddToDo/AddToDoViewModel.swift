//
//  AddToDoViewModel.swift
//  MyToDo
//
//  Created by Ivan Ruiz Monjo on 12/2/21.
//

import Foundation

final class AddToDoViewModel: ObservableObject {

    enum State {
        case loading
        case loaded(categories: [Category])
        case saved(ToDo)
        case error(String)
    }

    @Published var state: State = .loading
    @Published var categoryIndex = 0

    private let storage: Storage

    init(storage: Storage = CoreDataStorage()) {
        self.storage = storage
    }

    func add(title: String, dueDate: Date) {
        guard case let .loaded(categories) = state else {
            state = .error("Uneable to load categories")
            return
        }
        let category = categories[categoryIndex]
        let todo = storage.addToDo(title: title, dueDate: dueDate, category: category)
        state = .saved(todo)
    }

    func refresh() {
        state = .loaded(categories: storage.getCategories())
    }

    func didAddCategory(_ category: Category) {
        refresh()
        guard case let .loaded(categories) = state else {
            state = .error("Uneable to load categories")
            return
        }
        categoryIndex = categories.firstIndex { $0.title == category.title } ?? 0
    }
}
