//
//  ToDoListView.swift
//  MyToDo
//
//  Created by Ivan Ruiz Monjo on 12/2/21.
//

import SwiftUI

struct ToDoListView: View {
    
    @StateObject var viewModel = ToDoListViewModel()
    @State var isSearching = false
    @State private var mainList = [ToDo]()
    @State private var searchList = [ToDo]()
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBarView() { text in
                    viewModel.didSearch(text)
                }
                List {
                    ForEach(isSearching ? searchList: mainList) { todo in
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
        .onReceive(viewModel.$todos) { todos in
            mainList = todos
        }
    }
}

struct ToDoListView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListView()
    }
}

protocol Searchable {
    var searchableText: String { get }
}

extension ToDo: Searchable {
    var searchableText: String { title }
}
