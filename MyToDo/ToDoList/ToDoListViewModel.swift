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
    private var searchText = "" { didSet { refresh() }}
    var filters: ToDoFilter!

    init(storage: CoreDataStorage = CoreDataStorage.shared) {
        self.storage = storage
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSManagedObjectContext.didSaveObjectsNotification, object: nil)
    }

    func delete(indexSet: IndexSet) {
        indexSet.forEach {
            storage.delete(todos[$0])
        }
        todos.remove(atOffsets: indexSet)
    }

    func didSearch(_ text: String) {
        searchText = text
    }

    @objc func refresh() {
        var predicates = [NSPredicate]()
        if !searchText.isEmpty {
            predicates.append(searchPredicate())
        }
        if filters.upcoming {
            let startDate = Date() as NSDate
            let endDate = Date().addingWeek as NSDate
            predicates.append(NSPredicate(format: "dueDate > %@ && dueDate < %@", startDate, endDate))
        }
        if !filters.categories.isEmpty {
            var categoryPredicates = [NSPredicate]()
            filters.categories.forEach { category  in
                categoryPredicates.append(NSPredicate(format: "category == %@", category))
            }
            predicates.append(NSCompoundPredicate(orPredicateWithSubpredicates: categoryPredicates))
        }
        let andPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
		DispatchQueue.main.async {
			let items: Result<[ToDo], Error> = self.storage.items(entity: ToDo.self, predicate: andPredicate, sortDescriptors: nil)
			self.todos = (try? items.get()) ?? []
		}
    }

    private func searchPredicate() -> NSPredicate {
        let predicate1 = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
        let predicate2 = NSPredicate(format: "category.title CONTAINS[cd] %@", searchText)
        return NSCompoundPredicate(orPredicateWithSubpredicates: [predicate1, predicate2])
    }
}
