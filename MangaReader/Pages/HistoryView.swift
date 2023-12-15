//
// Created by Matthew Demers on 12/7/23.
//

import Foundation
import SwiftData
import SwiftUI

struct HistoryView: View {
  @Environment(\.modelContext) private var modelContext
  @Query private var history: [History]

  var body: some View {
    NavigationStack {
      HStack {
        Text("History")
            .font(.largeTitle.bold())
            .padding()
      }
          .frame(maxWidth: .infinity, alignment: .leading)
      List {
        ForEach(history, id: \.self) { entry in
          NavigationLink(destination: MangaDetailView(mangaId: entry.mangaId)) {

            VStack(alignment: .leading) {
              Text(entry.mangaName)
              HStack {
                Text(entry.lastRead, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text("Viewed: \(entry.chapterIds.count) / \(entry.totalChapters) Chapters")
                    .font(.caption)
                    .foregroundColor(.secondary)
              }
            }
          }
        }
            .onDelete(perform: deleteHistoryEntry)

      }
          .overlay(content: {
            if history.isEmpty {
              ContentUnavailableView(
                  "No history yet",
                  systemImage: "clock",
                  description: Text("Your history will appear here when you start reading manga")
              )
            }
          })
    }
  }

  func deleteHistoryEntry(at offsets: IndexSet) {
    for index in offsets {
      let entry = history[index]
      modelContext.delete(entry)
    }
  }
}