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
    private let storage: CoreDataStorage

    init(storage: CoreDataStorage = .shared) {
        self.storage = storage
    }

	func add(title: String, dueDate: Date, categoryIndex: Int, priority: String) {
        guard case let .loaded(categories) = state else {
            state = .error("Uneable to load categories")
            return
        }
        let category = categories[categoryIndex]
		let todo = storage.addToDo(title: title, dueDate: dueDate, category: category, priorty: Int(priority)!)
        state = .saved(todo)
    }

    func refresh() {
        let result: Result<[Category], Error> = storage.items(entity: Category.self)
        switch result {
        case .success(let items):
            state = .loaded(categories: items)
        case .failure(let error):
            state = .error(error.localizedDescription)
        }
    }

    func didAddCategory(_ category: Category) {
        refresh()
        guard case let .loaded(categories) = state else {
            state = .error("Uneable to load categories")
            return
        }
        categoryIndex = categories.firstIndex { $0 === category } ?? 0
    }
}
