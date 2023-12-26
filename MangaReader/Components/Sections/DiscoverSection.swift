//
// Created by Matthew Demers on 12/26/23.
//

import Foundation
import SwiftUI

struct DiscoverSection: View {
  let mangas: [Manga]
  let loadMoreMangas: () -> Void
  let geometry: GeometryProxy

  private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }

  var body: some View {
    if !mangas.isEmpty {
      Section {
        let isLandscape = geometry.size.width > geometry.size.height
        let columnsCount = idiom == .pad ? (isLandscape ? 3 : 2) : 1
        let columns: [GridItem] = Array(repeating: .init(.flexible()), count: columnsCount)

        LazyVGrid(columns: columns, spacing: 20) {
          ForEach(mangas, id: \.id) { manga in
            MangaCardView(manga: manga, showTags: false)
          }
        }

        Button(action: loadMoreMangas) {
          Text("Load more")
        }
            .padding(.bottom, 16)
      } header: {
        Text("Discover")
            .font(.headline)
            .padding(.top, 8)
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemBackground))
      }
          .padding(.horizontal, 8)
    }
  }
}
