//
//  AddCategoryViewModel.swift
//  MyToDo
//
//  Created by Ivan Ruiz Monjo on 12/2/21.
//

import Foundation

final class AddCategoryViewModel: ObservableObject {

    let images = ["hammer.fill", "house.fill", "desktopcomputer", "cart.fill", "photo", "wand.and.rays", "car", "heart.text.square", "ladybug", "gamecontroller"]
    @Published var categories = [Category]()

    private let storage: CoreDataStorage

    init(storage: CoreDataStorage = .shared) {
        self.storage = storage
    }

    func refresh() {
        let items: Result<[Category], Error> = storage.items(entity: Category.self)
        if let categories = try? items.get() {
            self.categories = categories
        }
    }

    func add(title: String, imageIndex: Int) -> Category {
        let imageName = images[imageIndex]
        return storage.addCategory(title: title, imageName: imageName)
    }

    func delete(indexSet: IndexSet) {
        indexSet.forEach { index in
            storage.delete(categories[index])
        }
        categories.remove(atOffsets: indexSet)
    }
}
