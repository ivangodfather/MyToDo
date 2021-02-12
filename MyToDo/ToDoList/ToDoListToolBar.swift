//
//  ToDoListToolBar.swift
//  MyToDo
//
//  Created by Ivan Ruiz Monjo on 12/2/21.
//

import SwiftUI

struct ToDoListToolBar: ToolbarContent {

    let viewModel: ToDoListViewModel

    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Image(systemName: "plus.rectangle.on.folder")
        }
    }
}
