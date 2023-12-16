//
//  MangaReaderApp.swift
//  MangaReader
//
//  Created by Matthew Demers on 11/28/23.
//

import SwiftUI
import SwiftData

typealias Account = SchemaV2.Account
typealias History = SchemaV2.History
typealias ReadingListGroup = SchemaV2.ReadingListGroup
typealias ReadingListItem = SchemaV2.ReadingListItem

@main
struct MangaReaderApp: App {
    @State private var isActive: Bool = false
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Account.self,
            History.self,
            ReadingListGroup.self,
            ReadingListItem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            if isActive {
                ContentView() // Your main view
            } else {
                SplashScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { // 3-second delay
                            withAnimation {
                                self.isActive = true
                            }
                        }
                    }
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
