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
                    Label(todo.title ?? "", systemImage: todo.category?.imageName ?? "")
                }.onDelete(perform: viewModel.delete)
            }
            .toolbar { ToDoListToolBar(viewModel: viewModel) }
        }.onAppear(perform: viewModel.refresh)
    }
}

struct ToDoListView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListView()
    }
}
