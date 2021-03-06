//
//  ToDoListToolBar.swift
//  MyToDo
//
//  Created by Ivan Ruiz Monjo on 12/2/21.
//

import SwiftUI

struct ToDoListToolBar: ToolbarContent {


    @Binding var showFilterView: Bool
    let hasFilters: Bool

    var body: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("To do list")
        }
        ToolbarItem(placement: .navigationBarLeading) {
            NavigationLink(destination: AddToDoView()) {
                Image(systemName: "plus")
            }
        }
		ToolbarItem(placement: .navigationBarLeading) {
			Button(action: { CoreDataStorage.shared.deleteAll() 
			}) {
				Image(systemName: "minus.square.fill")
			}
		}

        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: { showFilterView = true }) {
                Image(systemName: hasFilters ? "line.horizontal.3.decrease.circle.fill": "line.horizontal.3.decrease.circle")
            }
        }
		ToolbarItem(placement: .navigationBarTrailing) {
			Button(action: { CoreDataStorage.shared.importFromResponse(remoteResponse())
			}) {
				Image(systemName: "square.and.arrow.down.on.square")
			}
		}
    }
}
