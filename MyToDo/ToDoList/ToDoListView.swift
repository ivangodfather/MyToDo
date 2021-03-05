//
//  ToDoListView.swift
//  MyToDo
//
//  Created by Ivan Ruiz Monjo on 12/2/21.
//

import SwiftUI

struct ToDoListView: View {
    
    @StateObject private var viewModel = ToDoListViewModel()
    @State private var showFilterView = false
    @EnvironmentObject var filters: ToDoFilter

    var body: some View {
        NavigationView {
            VStack {
                SearchBarView { text in
                    viewModel.didSearch(text)
                }
                List {
                    ForEach(viewModel.todos) { todo in
                        NavigationLink(
                            destination: ToDoDetail(todo: todo)) {
                            VStack {
                                Label(todo.title, systemImage: todo.category?.imageName ?? "")
                                Text("Priority: \(todo.priority.value)")
								Text("User:\(todo.user ?? "Empty") Notes: \(todo.notes ?? "Empty")")
                            }
                        }
                    }.onDelete(perform: viewModel.delete)
                }
                .listStyle(PlainListStyle())
            }
            .sheet(isPresented: $showFilterView) {
                FilterView() {
                    viewModel.refresh()
                    showFilterView = false
                }
            }
            .toolbar {
                ToDoListToolBar(showFilterView: $showFilterView, hasFilters: filters.hasFilters)
            }
        }
        .onAppear {
            viewModel.filters = filters
            viewModel.refresh()
        }
    }
}

struct ToDoListView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListView()
    }
}
