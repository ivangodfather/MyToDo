//
//  CoreDataStorage+Category.swift
//  MyToDo
//
//  Created by Ivan Ruiz Monjo on 18/2/21.
//

import Foundation

extension CoreDataStorage {
    func addCategory(title: String, imageName: String) -> Category {
        let category = Category(context: viewContext)
        category.title = title
        category.imageName = imageName
        save()
        return category
    }
}
