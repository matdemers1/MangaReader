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
  @Query private var readingListGroups: [ReadingListGroup]

  @State private var selection = "home"

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

        ReadingListView()
            .tabItem {
              Label("Reading List", systemImage: "book")
            }
            .tag("readingList")

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
        .onAppear() {
          if readingListGroups.isEmpty {
            let defaultGroups = [
              ReadingListGroup(groupId: UUID(), groupName: "Plan to Read"),
              ReadingListGroup(groupId: UUID(), groupName: "Reading"),
            ]
            defaultGroups.forEach { group in
              try! modelContext.insert(group)
            }
          }
        }
  }
}
