//
//  SearchBarView.swift
//  MyToDo
//
//  Created by Ivan Ruiz Monjo on 20/2/21.
//

import SwiftUI

struct SearchBarView: View {

    @State private var search: String = ""
    @State private var isSearching: Bool = false
    var searchBlock: (String) -> ()
    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .imageScale(.small)
                    TextField("", text: $search)
                        .onChange(of: search) { searchText in
                            searchBlock(searchText)
                            withAnimation {
                                isSearching = !searchText.isEmpty
                            }
                        }
                        .foregroundColor(.primary)
                        .accentColor(.primary)
                        .disableAutocorrection(true)
                    if !search.isEmpty {
                        Button(action: {
                            search = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                        }
                    }
                }
                .foregroundColor(Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)))
                .padding(5)
                .background(Color(#colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8745098039, alpha: 1)).cornerRadius(8.0))
                if isSearching {
                    Button(action: {
                        withAnimation {
                            isSearching = false
                        }
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }) {
                        Text("Cancel")
                    }
                    .padding(4)
                }
            }
            .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
        }
        .frame(height: 50)
        .padding(.horizontal)
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(searchBlock: { _ in })
    }
}
