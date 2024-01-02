//
// Created by Matthew Demers on 12/26/23.
//

import Foundation
import SwiftUI

class MangaDetailViewModel: ObservableObject {
  func addMangaToReadingList( selectedGroup: UUID, mangaId: String, manga: Manga?, readingListGroups: [ReadingListGroup]) {
    if let group = readingListGroups.first(where: { $0.groupId == selectedGroup}) {
      group.readingListItems.append(ReadingListItem(mangaId: mangaId, mangaName: manga?.attributes.title["en"] ?? "Unknown Manga"))
    }
  }

  func getChapterScanlationGroup(chapter: Chapter) -> RelationshipAttributes? {
    let chapterGroup = chapter.relationships.first(where: { $0.type == "scanlation_group" })
    return chapterGroup?.attributes ?? nil
  }

  func fetchManga(mangaId: String, manga: Binding<Manga?>) {
    let url = URL(string: "https://api.mangadex.org/manga/\(mangaId)?includes[]=cover_art")!
    let request = URLRequest(url: url)

    URLSession.shared.dataTask(with: request) { data, response, error in
          if let data = data {
            do {
              let mangaResponse = try JSONDecoder().decode(MangaResponse.self, from: data)
              DispatchQueue.main.async {
                manga.wrappedValue = mangaResponse.data.first // Update your state variable here
              }
            } catch {
              print("Error decoding JSON: \(error)")
            }
          }
        }.resume()
  }

  func fetchChapterResponse(mangaId: String, offset: Int = 0, chapters: Binding<[Chapter]?>, showMoreButton: Binding<Bool>, chaptersResponse: Binding<ChapterResponse?>) {
    let url = URL(string: "https://api.mangadex.org/manga/\(mangaId)/feed?translatedLanguage[]=en&order[chapter]=desc&limit=500&offset=\(offset*999)&contentRating[]=safe&contentRating[]=suggestive&contentRating[]=erotica&contentRating[]=pornographic&includes[]=scanlation_group")!
    let request = URLRequest(url: url)

    URLSession.shared.dataTask(with: request) { data, response, error in
          if let data = data {
            do {
              let chapterResponse = try JSONDecoder().decode(ChapterResponse.self, from: data)
              DispatchQueue.main.async {
                  chapters.wrappedValue?.append(contentsOf: chapterResponse.data )
                  print("Chapters: \(chapters.wrappedValue?.count ?? 0) / \(chapterResponse.total )")
                if chapters.wrappedValue?.count == chapterResponse.total {
                  showMoreButton.wrappedValue = false
                }
                chaptersResponse.wrappedValue = chapterResponse
              }
            } catch {
              print("Error decoding JSON: \(error)")
            }
          }
        }.resume()
  }
}
