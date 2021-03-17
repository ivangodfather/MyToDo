//
//  MyToDoApp.swift
//  MyToDo
//
//  Created by Ivan Ruiz Monjo on 12/2/21.
//

import SwiftUI

@main
struct MyToDoApp: App {
    @StateObject private var filter = ToDoFilter()
    var body: some Scene {
        WindowGroup {
            ToDoListView()
				.environmentObject(filter).onAppear {
					CoreDataStorage.shared.setup {
						
					}
				}
        }
    }
}
