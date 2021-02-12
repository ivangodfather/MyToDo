//
//  AddToDoView.swift
//  MyToDo
//
//  Created by Ivan Ruiz Monjo on 12/2/21.
//

import SwiftUI

struct AddToDoView: View {

    @StateObject private var viewModel = AddToDoViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State var dismissView = false
    @State private var todoTitle: String = ""
    @State private var categoryIndex = 0
    @State private var dueDate = Date()

    var body: some View {
        Group {
            switch viewModel.state {
            case .loading: ProgressView().onAppear(perform: viewModel.refresh)
            case .loaded(let categories):
                AddTodoLoadedView(viewModel: viewModel,
                                  categories: categories,
                                  todoTitle: $todoTitle,
                                  categoryIndex: $categoryIndex,
                                  dueDate: $dueDate)
            case .error(let error): Text(error)
            default: EmptyView()
            }
        }
        .toolbar {
            AddToDoToolBar {
                viewModel.add(title: todoTitle, dueDate: dueDate, categoryIndex: categoryIndex)
            }
        }.onReceive(viewModel.$state) { state in
            if case .saved(_) = state {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct AddToDoView_Previews: PreviewProvider {
    static var previews: some View {
        AddToDoView()
    }
}
