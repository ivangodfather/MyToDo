//
//  AddCategoryToolBar.swift
//  MyToDo
//
//  Created by Ivan Ruiz Monjo on 12/2/21.
//

import SwiftUI

struct AddCategoryToolBar: ToolbarContent {
    let didTapSave: () -> ()
    let didTapClose: () -> ()

    var body: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("Add new category")
        }
        ToolbarItem(placement: .cancellationAction) {
            Button("Close") { didTapClose() }
        }
        ToolbarItem(placement: .primaryAction) {
            Button("Save") { didTapSave() }
        }
    }
}
