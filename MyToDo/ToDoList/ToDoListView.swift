//
//  ToDoListView.swift
//  MyToDo
//
//  Created by Ivan Ruiz Monjo on 12/2/21.
//

import SwiftUI

struct ToDoListView: View {

    @StateObject var viewModel = ToDoListViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.todos) { todo in
                    Text(todo.title ?? "")
                }
            }
            .toolbar { ToDoListToolBar(viewModel: viewModel) }
        }
    }
}

struct ToDoListView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListView()
    }
}
