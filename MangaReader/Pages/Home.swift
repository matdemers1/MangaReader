//
//  Home.swift
//  MangaReader
//
//  Created by Matthew Demers on 11/28/23.
//

import Foundation
import SwiftUI

struct HomeView: View {
    let mangas: [Manga] = loadMockData()
    
    var body: some View {
        ScrollView {
            Text("Home")
                .font(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
            LazyVStack {
                ForEach(mangas, id: \.id) { manga in
                    MangaCardView(manga: manga)
                }
            }
        }
        .padding()
    }
}
