//
//  Date+.swift
//  MyToDo
//
//  Created by Ivan Ruiz Monjo on 23/2/21.
//

import Foundation

extension Date {
    var addingWeek: Date {
        addingTimeInterval(60 * 60 * 24 * 7)
    }
}
