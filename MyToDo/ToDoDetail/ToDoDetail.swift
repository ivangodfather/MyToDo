//
//  ToDoDetail.swift
//  MyToDo
//
//  Created by Ivan Ruiz Monjo on 22/2/21.
//

import SwiftUI

struct ToDoDetail: View {

    let todo: ToDo
    @State private var title: String
    @State private var dueDate: Date

    init(todo: ToDo) {
        self.todo = todo
        _title = State(wrappedValue: todo.title)
        _dueDate = State(wrappedValue: todo.dueDate)
    }

    var body: some View {
        VStack {
            GroupBox(label: Label(todo.category?.title ?? "", systemImage: todo.category?.imageName ?? "")) {
                TextField("Title", text: $title)
                DatePicker("Due date", selection: $dueDate)
            }.groupBoxStyle(DetailGroupBoxStyle())
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {}) {
                    Text("Save")
                }
            }
        }
    }
}

struct ToDoDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ToDoDetail(todo: .random())
        }
    }
}
