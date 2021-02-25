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
            VStack {
                SearchBarView() { text in
                    viewModel.didSearch(text)
                }
                List {
                    ForEach(viewModel.todos) { todo in
                        NavigationLink(
                            destination: ToDoDetail(todo: todo)) {
                            Label(todo.title, systemImage: todo.category?.imageName ?? "")
                        }
                    }.onDelete(perform: viewModel.delete)
                }
                .listStyle(PlainListStyle())
            }
            .toolbar { ToDoListToolBar(viewModel: viewModel) }
        }
        .onAppear(perform: viewModel.refresh)
    }
}

struct ToDoListView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListView()
    }
}
