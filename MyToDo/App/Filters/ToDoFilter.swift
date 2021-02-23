//
//  ToDoFilter.swift
//  MyToDo
//
//  Created by Ivan Ruiz Monjo on 23/2/21.
//

import SwiftUI

final class ToDoFilter: ObservableObject {
    @Published var upcoming: Bool = false { didSet { update() } }
    @Published var categories: [Category] = [] { didSet { update() } }
    @Published var hasFilters = false

    private func update() {
        hasFilters = upcoming || !categories.isEmpty
    }
}
