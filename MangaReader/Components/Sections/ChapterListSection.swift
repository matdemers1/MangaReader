//
// Created by Matthew Demers on 1/1/24.
//

import Foundation
import SwiftUI

struct ChapterListSection: View{
  @Binding var chapters: [Chapter]?
  @Binding var offset: Int
  @Binding var showMoreButton: Bool
  @Binding var chaptersResponse: ChapterResponse?
  let historyForMangaId: History?
  let manga: Manga
  @StateObject var viewModel = MangaDetailViewModel()

  var body: some View {
    VStack(alignment: .leading) {
      Text("Chapters")
          .font(.subheadline)
          .padding(.bottom, 4)
      if let chapters = chapters {
        ForEach(chapters, id: \.id) { chapter in
          NavigationLink(destination: ChapterViewWrapper(
              totalChapters: chaptersResponse?.total ?? 0,
              chapters: chapters,
              chapterId: chapter.id.description,
              mangaId: manga.id.description,
              mangaName: manga.attributes.title["en"] ?? "N/A",
              coverArtURL: manga.coverArt?.fullCoverURL ?? "N/A",
              isLongStrip: manga.attributes.tags?.contains(where: { $0.attributes.name["en"] == "Long Strip" }) ?? false
          )) {
            VStack {
              ChapterListItem(
                  chapter: chapter,
                  historyForMangaId: historyForMangaId
              )
              Divider()
                  .overlay(Color.gray)
                  .frame(height: 4)
            }
          }
        }
        if showMoreButton {
          Button(action: {
            offset += 1
            viewModel.fetchChapterResponse(
                mangaId: manga.id.description,
                offset: offset,
                chapters: $chapters,
                showMoreButton: $showMoreButton,
                chaptersResponse: $chaptersResponse
            )
          }) {
            Text("Load more chapters")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
          }
        }
      } else {
        Text("No chapters available")
      }
    }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
  }
}