//
//  SuggestionsContainer.swift
//  MangaReader
//
//  Created by Matthew Demers on 1/25/24.
//

import Foundation
import SwiftUI

struct SuggestionsContainer: View {
  let manga: Manga
  private let mangaViewModel = MangaDetailViewModel()
  @State private var suggestions: [Manga] = []
  
  var body: some View {
    Section {
      ScrollView(.horizontal, showsIndicators: false) {
        HStack {
          ForEach(suggestions.filter { $0.id != manga.id }, id: \.id) { manga in
            MangaHistoryCard(
              mangaId: manga.id,
              coverArtUrl: manga.coverArt?.thumbnailURL256,
              mangaName: manga.attributes.title["en"] ?? "No Title",
              lastRead: nil
            )
          }
        }
        .padding(.horizontal, 8)
      }
    } header: {
      Text("Suggestions")
        .font(.headline)
        .padding(.top, 8)
        .padding(.horizontal, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
    }
    .onAppear {
      mangaViewModel.fetchMangaSuggestions(
        tags: manga.attributes.tags ?? [],
        showAdultContent: true,
        isTranslatedTo: "en",
        mangaSuggestions: $suggestions
      )
    }
  }
}

#Preview {
  SuggestionsContainer(manga: MOCK_MANGA_OBJECT)
}
