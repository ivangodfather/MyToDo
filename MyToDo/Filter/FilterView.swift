//
//  FilterView.swift
//  MyToDo
//
//  Created by Ivan Ruiz Monjo on 23/2/21.
//

import SwiftUI

struct FilterView: View {
    
    let completion: () -> ()
    @EnvironmentObject var filters: ToDoFilter
    @StateObject private var viewModel = FilterViewModel()

    init(didAddFilter: @escaping () -> ()) {
        self.completion = didAddFilter
    }

    var body: some View {
        NavigationView {
            Form {
                Toggle("Show only upcoming", isOn: $filters.upcoming)
                Section(header: Text("Categories")) {
                    ForEach(viewModel.selectableCategories, id: \.category) { selectable in
                        HStack {
                            Label(selectable.category.title, systemImage: selectable.category.imageName ?? "").onTapGesture {
                                viewModel.didTap(selectable.category, with: filters)
                            }
                            Spacer()
                            if selectable.isSelected {
                                Spacer()
                                Image(systemName: "checkmark").foregroundColor(.blue)
                            }
                        }
                    }
                }
            }.toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Filter your to do's")
                }
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        completion()
                    }) {
                        Text("Done")
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        viewModel.reset(filters)
                    }) {
                        Text("Reset filters")
                    }
                }
            }
            .onAppear {
                viewModel.viewDidAppear(filters: filters)
                // unsure if there is a better way to do this. I would like to pass in FilterViewModel.init but I can't since those
                // those filters comes in EnvironmentObject, and I can't access this object in FilterView.init
            }
            .onDisappear {
                completion()
            }
        }
    }
}
