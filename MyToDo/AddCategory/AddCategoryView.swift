//
//  AddCategoryView.swift
//  MyToDo
//
//  Created by Ivan Ruiz Monjo on 12/2/21.
//

import SwiftUI

struct AddCategoryView: View {

    let completion: (Category) -> ()

    @StateObject private var viewModel = AddCategoryViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var imageIndex = 0
    @State private var title = ""

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Category details")) {
                    TextField("Enter category title", text: $title)
                    Picker(selection: $imageIndex, label: Text("Category Image")) {
                        ForEach(Array(viewModel.images.enumerated()), id: \.offset) { offset, image in
                            Image(systemName: image)
                        }
                    }
                }
                Section(header: Text("Existing categories")) {
                    ForEach(viewModel.categories) { category in
                        HStack {
                            Image(systemName: category.imageName ?? "")
                            Text(category.title ?? "")
                        }
                    }.onDelete(perform: viewModel.delete)
                }
            }
            .listStyle(GroupedListStyle())
            .toolbar {
                AddCategoryToolBar {
                    let category = viewModel.add(title: title, imageIndex: imageIndex)
                    completion(category)
                } didTapClose: { presentationMode.wrappedValue.dismiss() }
            }
            .onAppear(perform: viewModel.refresh)
        }
    }
}

struct AddCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        AddCategoryView(completion: { _ in })
    }
}
