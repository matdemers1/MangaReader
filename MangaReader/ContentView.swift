//
//  ContentView.swift
//  MangaReader
//
//  Created by Matthew Demers on 11/28/23.
//

import SwiftUI
import SwiftData

enum Tab {
  case home, search, readingList, history, account
}

struct ContentView: View {
  @Environment(\.modelContext) private var modelContext
  @Query private var readingListGroups: [ReadingListGroup]

  @State private var selectedTab: Tab = .home

  var body: some View {
    NavigationView {
      TabView(selection: $selectedTab) {
        HomeView()
            .tabItem {
              Label("Home", systemImage: "house")
            }
            .tag(Tab.home)

        SearchView()
            .tabItem {
              Label("Search", systemImage: "magnifyingglass")
            }
            .tag(Tab.search)

        ReadingListView()
            .tabItem {
              Label("Reading List", systemImage: "book")
            }
            .tag(Tab.readingList)

        HistoryView()
            .tabItem {
              Label("History", systemImage: "clock")
            }
            .tag(Tab.history)

        AccountView()
            .tabItem {
              Label("Account", systemImage: "person")
            }
            .tag(Tab.account)
      }
    }
        .onAppear() {
          let tabBarAppearance = UITabBarAppearance()
          tabBarAppearance.configureWithDefaultBackground()
          UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
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