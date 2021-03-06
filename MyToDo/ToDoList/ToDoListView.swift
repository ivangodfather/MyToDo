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
							HStack {
								if let data = todo.attachments?.first?.image {
									Image(uiImage: UIImage(data: data)!)
										.resizable().frame(width: 100, height: 100, alignment: .center)
								}
								VStack {
									Label(todo.title, systemImage: todo.category?.imageName ?? "")
									Text("Priority: \(todo.priority.value)")
								}
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
