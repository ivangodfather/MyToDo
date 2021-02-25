//
//  ToDoFilter.swift
//  MyToDo
//
//  Created by Ivan Ruiz Monjo on 23/2/21.
//

import SwiftUI

final class ToDoFilter: ObservableObject {
    @Published var upcoming: Bool = false
    @Published var categories: [Category] = []
    var hasFilters: Bool { upcoming || !categories.isEmpty }
}
