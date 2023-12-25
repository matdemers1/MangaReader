//
// Created by Matthew Demers on 12/24/23.
//

import Foundation
import SwiftUI

struct DiscoverSection: View {
  let historyItems: [History]
  let mangas: [Manga]
  let loadMoreMangas: () -> Void

  var body: some View {
    if !mangas.isEmpty {
      VStack {
        ForEach(mangas, id: \.id) { manga in
          MangaCardView(manga: manga, showTags: false)
        }
        Button(action: loadMoreMangas) {
          Text("Load more")
        }
            .padding(.bottom, 16)
      }
          .padding(.horizontal, 8)
    }
  }
}