//
//  ToDoDetailViewModel.swift
//  MyToDo
//
//  Created by Ivan Ruiz Monjo on 22/2/21.
//

import Foundation
import CoreData

final class ToDoDetailViewModel: ObservableObject {

    @Published var todo: ToDo
    @Published var categories: [Category] = []
    @Published var selectedCategoryIndex = 0 {
        willSet {
            todo.category = categories[newValue]
        }
    }

    private let childContext: NSManagedObjectContext
    private let storage = CoreDataStorage()

    init(todo: ToDo) {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        childContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        childContext.parent = todo.managedObjectContext
        do {
            categories = try childContext.fetch(request)
        } catch {
            fatalError("Uneable to load categories")
        }
        
        guard let item = try? childContext.existingObject(with: todo.objectID) as? ToDo else {
            fatalError("Uneable to load to do")
        }
        self.todo =  item
        selectedCategoryIndex = categories.firstIndex { $0.objectID == todo.category?.objectID } ?? 0
    }

    func save(completed: () -> ()) {
        try? childContext.save()
        CoreDataStorage.shared.save()
        completed()
    }

    func didDisappear() {
        if childContext.hasChanges {
            childContext.refresh(todo, mergeChanges: false)
        }
    }
}
