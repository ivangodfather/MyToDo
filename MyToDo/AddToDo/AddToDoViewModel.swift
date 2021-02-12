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

    private let storage: Storage
    private var selectedCategory: Category? = nil

    init(storage: Storage = CoreDataStorage()) {
        self.storage = storage
    }

    func add(title: String, dueDate: Date, categoryIndex: Int) {
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
}
