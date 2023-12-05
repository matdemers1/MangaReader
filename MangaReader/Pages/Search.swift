//
//  Search.swift
//  MangaReader
//
//  Created by Matthew Demers on 11/28/23.
//

import Foundation
import SwiftUI

struct SearchView: View {
    @State var showSheet = false
    var body: some View {
        VStack {
            Text("Search")
                .font(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search", text: .constant(""))
                Spacer()
                Button(action: {
                    showSheet.toggle()
                }) {
                    Image(systemName: "slider.horizontal.3")
                }
                    .sheet(isPresented: $showSheet, content: {
                        FilterView()
                    })
            }
                .padding(.horizontal, 8)
        }
    }
}
