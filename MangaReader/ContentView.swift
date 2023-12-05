//
//  ContentView.swift
//  MangaReader
//
//  Created by Matthew Demers on 11/28/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        NavigationView {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }

                SearchView()
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
        .colorScheme(.dark)
}
