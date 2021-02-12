//
//  AddTodoLoadedView.swift
//  MyToDo
//
//  Created by Ivan Ruiz Monjo on 12/2/21.
//

import SwiftUI

struct AddTodoLoadedView: View {
    let viewModel: AddToDoViewModel
    let categories: [Category]
    @Binding var todoTitle: String
    @Binding var categoryIndex: Int
    @Binding var dueDate: Date

    @State private var showAddCategory = false


    var body: some View {
        List {
            Section(header: Text("To do details")) {
                TextField("Write your to do title", text: $todoTitle)
                DatePicker("Select due date", selection: $dueDate, displayedComponents: .date)
            }
            Section(header: Text("Category"), footer: categoryFooter) {
                Picker("Select a category", selection: $categoryIndex) {
                    ForEach(Array(categories.enumerated()), id: \.offset) { idx, category in
                        HStack {
                            Image(systemName: category.imageName ?? "")
                            Text(category.title ?? "").tag(idx)
                        }
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
        .sheet(isPresented: $showAddCategory, onDismiss: {}) {
            AddCategoryView { category in
                showAddCategory = false
                viewModel.refresh()
                categoryIndex = categories.firstIndex { $0 == category } ?? 0
            }
        }
    }

    var categoryFooter: some View {
        Button(action: { showAddCategory.toggle() }, label: {
            Text("Add new category")
        })
    }
}

struct AddTodoLoadedView_Previews: PreviewProvider {
    static var previews: some View {
        AddTodoLoadedView(viewModel: AddToDoViewModel(), categories: [], todoTitle: .constant(""), categoryIndex: .constant(0), dueDate: .constant(Date()))
    }
}
