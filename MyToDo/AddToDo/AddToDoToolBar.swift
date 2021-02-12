//
//  AddToDoToolBar.swift
//  MyToDo
//
//  Created by Ivan Ruiz Monjo on 12/2/21.
//

import SwiftUI

struct AddToDoToolBar: ToolbarContent {
    let didTapSave: () -> ()

    var body: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("Add to do")
        }
        ToolbarItem(placement: .primaryAction) {
            Button(action: didTapSave) {
                Text("Save")
            }
        }
    }
}
