//
// Created by Matthew Demers on 12/18/23.
//

import Foundation
import SwiftUI
import SwiftData

struct UserHistory: View{
  @Query var historyItems: [History]

  var body: some View {
    ScrollView {
      LazyVStack {
        ForEach(historyItems) { historyItem in
          MangaHistoryCard(
            mangaId: historyItem.mangaId,
            coverArtUrl: historyItem.coverArtURL,
            mangaName: historyItem.mangaName,
            lastRead: historyItem.lastRead
          )
        }
      }
    }
  }
}
