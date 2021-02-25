//
//  ToDoDetail.swift
//  MyToDo
//
//  Created by Ivan Ruiz Monjo on 22/2/21.
//

import SwiftUI
import CoreData

struct ToDoDetail: View {
    
    @StateObject private var viewModel: ToDoDetailViewModel
    @Environment(\.presentationMode) var presentationMode

    init(todo: ToDo) {
        self._viewModel = StateObject(wrappedValue: ToDoDetailViewModel(todo: todo))
    }

    var body: some View {
        VStack {
            GroupBox(label: categoryView) {
                TextField("Title", text: $viewModel.todo.title)
                DatePicker("Due date", selection: $viewModel.todo.dueDate)
            }.groupBoxStyle(DetailGroupBoxStyle())
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.save {
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Save")
                }
            }
        }.onDisappear(perform: viewModel.didDisappear)
    }


    @ViewBuilder private var categoryView: some View {
        Picker(selection: $viewModel.selectedCategoryIndex, label: categoryLabel) {
            ForEach(Array(viewModel.categories.enumerated()), id: \.offset) { offset, category in
                Text(category.title).tag(offset)
            }
        }.pickerStyle(MenuPickerStyle())
    }

    private var categoryLabel: some View {
        Label(viewModel.categories[viewModel.selectedCategoryIndex].title,
              systemImage: viewModel.categories[viewModel.selectedCategoryIndex].imageName ?? "")
    }
}

struct ToDoDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ToDoDetail(todo: .random())
        }
    }
}
