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
  @State private var selection = "account"

  var body: some View {
    NavigationView {
      TabView(selection: $selection) {
        HomeView()
            .tabItem {
              Label("Home", systemImage: "house")
            }
            .tag("home")

        SearchView()
            .tabItem {
              Label("Search", systemImage: "magnifyingglass")
            }
            .tag("search")

        AccountView()
            .tabItem {
              Label("Account", systemImage: "person")
            }
            .tag("account")
      }
    }
  }
}

#Preview {
  ContentView()
      .modelContainer(for: Item.self, inMemory: true)
      .colorScheme(.dark)
}
