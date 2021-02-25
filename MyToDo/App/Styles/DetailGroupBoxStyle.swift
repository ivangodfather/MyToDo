//
//  DetailGroupBoxStyle.swift
//  MyToDo
//
//  Created by Ivan Ruiz Monjo on 22/2/21.
//

import SwiftUI

struct DetailGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            configuration.label
            configuration.content
        }.padding()
    }
}
