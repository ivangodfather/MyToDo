//
//  CoreDataStorage.swift
//  MyToDo
//
//  Created by Ivan Ruiz Monjo on 12/2/21.
//

import CoreData

final class CoreDataStorage {

    private let persistentContainer: NSPersistentContainer
    var viewContext: NSManagedObjectContext { persistentContainer.viewContext }

    init() {
        persistentContainer = NSPersistentContainer(name: String(describing: CoreDataStorage.self))
        persistentContainer.loadPersistentStores { persistentStoreDescription, error in
            guard error == nil else {
                fatalError("Uneable to load. \(error?.localizedDescription ?? "")")
            }
        }
    }

    func save() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print("Uneable to save viewContext. \(error.localizedDescription)")
            }
        }
    }

    func delete(object: NSManagedObject) {
        viewContext.delete(object)
        save()
    }

    // MARK: ToDo

    func getToDos() -> [ToDo] {
        let request: NSFetchRequest<ToDo> = ToDo.fetchRequest()
        do {
            return try viewContext.fetch(request)
        } catch {
            print("Uneable to fetch ToDo. \(error.localizedDescription)")
        }
        return []
    }

    func addToDo(title: String, dueDate: Date, category: Category) -> ToDo {
        let todo = ToDo(context: viewContext)
        todo.title = title
        todo.dueDate = dueDate
        todo.category = category
        save()
        return todo
    }

    func deleteToDos(indexSet: IndexSet) {
        let items = getToDos()
        indexSet.forEach {
            delete(object: items[$0])
        }
        save()
    }

    // MARK: Category

    func addCategory(title: String, imageName: String) -> Category {
        let category = Category(context: viewContext)
        category.title = title
        category.imageName = imageName
        save()
        return category
    }


}
