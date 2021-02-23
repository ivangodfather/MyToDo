//
//  FilterViewModel.swift
//  MyToDo
//
//  Created by Ivan Ruiz Monjo on 23/2/21.
//

import SwiftUI

final class FilterViewModel: ObservableObject {

    @Published var selectableCategories = [SelectableCategory]()
    var filters: ToDoFilter!

    func reset(_ filters: ToDoFilter) {
        filters.categories = []
        filters.upcoming = false
        updateSelectedCategories()
    }

    func didTap(_ category: Category, with filters: ToDoFilter) {
        if filters.categories.contains(category) {
            filters.categories.removeAll(where: { $0 == category })
        } else {
            filters.categories.append(category)
        }
        updateSelectedCategories()
    }

    func viewDidAppear(filters: ToDoFilter) {
        self.filters = filters
        updateSelectedCategories()
    }

    private func updateSelectedCategories() {
        selectableCategories = []
        let categories = (try? CoreDataStorage.shared.items(entity: Category.self).get()) ?? []
        var result = [SelectableCategory]()
        categories.forEach { category in
            let isSelected = filters.categories.contains(category)
            let selectableCategory = SelectableCategory(category: category, isSelected: isSelected)
            result.append(selectableCategory)
        }
        selectableCategories = result
    }
}

struct SelectableCategory {
    let category: Category
    var isSelected: Bool
}
