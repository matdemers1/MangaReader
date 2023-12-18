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
          MangaHistoryCard(historyItem: historyItem)
        }
      }
    }
  }
}