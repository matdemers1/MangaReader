//
//  ContentView.swift
//  MangaReader
//
//  Created by Matthew Demers on 11/28/23.
//

import SwiftUI

struct ContentView: View {
  @State private var selection = "history"

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

        HistoryView()
            .tabItem {
              Label("History", systemImage: "clock")
            }
            .tag("history")

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
      .colorScheme(.dark)
}
