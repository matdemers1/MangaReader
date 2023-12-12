//
//  MangaDetailView.swift
//  MangaReader
//
//  Created by Matthew Demers on 11/28/23.
//

import Foundation
import SwiftUI
import SwiftData

struct MangaDetailView: View {
  @State var manga: Manga? = nil
  @State var mangaId: String = ""
  @State var chaptersResponse: ChapterResponse?
  @State var chapters: [Chapter]? = []
  @State var offset = 0
  @State var showMoreButton = true
  @State var historyForMangaId: History? = nil
  @Query var history: [History]


  var body: some View {
    ScrollView() {
      if let manga = manga {
        VStack(spacing: 0) {
          ZStack(alignment: .bottomLeading) {
            GeometryReader { geometry in
              if let coverArtURL = manga.coverArt?.fullCoverURL {
                AsyncImage(url: URL(string: coverArtURL)) { image in
                  image
                      .resizable()
                      .scaledToFill()
                      .frame(width: geometry.size.width)
                      .frame(height: geometry.size.height / 1)
                } placeholder: {
                  ProgressView()
                }
              }
            }
            LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom)
                .frame(height: 480)

            // Title and Artist name
            VStack(alignment: .leading) {
              Text(manga.attributes.title["en"] ?? "Unknown Title")
                  .font(.title2)
                  .foregroundColor(.white)
                  .padding(.top, 20)

              Text("Artist Placeholder")
                  .font(.subheadline)
                  .foregroundColor(.gray)
              Text(manga.id)
                  .font(.caption)
                  .foregroundColor(.secondary)
            }
                .padding()

          }
          // Manga Details
          VStack(alignment: .leading, spacing: 8) {
            ExpandableText(manga.attributes.description?["en"] ?? "No description", lineLimit: 6)
                .foregroundColor(.white)
                .padding()
          }
              .frame(maxWidth: .infinity, alignment: .leading)
              .background(Color.black)
          VStack(alignment: .leading) {
            Text("Chapters")
                .font(.subheadline)
                .padding(.bottom, 4)
            if let chapters = chapters {
              ForEach(chapters, id: \.id) { chapter in
                NavigationLink(destination: ChapterView(
                    totalChapters: chaptersResponse?.total ?? 0,
                    chapters: chapters,
                    chapterId: chapter.id.description ?? "N/A",
                    mangaId: manga.id.description,
                    mangaName: manga.attributes.title["en"] ?? "N/A"
                )) {
                  VStack {
                    HStack(alignment: .center) {
                      Text(chapter.attributes.chapter ?? "N/A")
                          .font(.headline)
                          .foregroundColor(
                              historyForMangaId?.chapterIds.contains(chapter.id.description) ?? false
                                  ? Color.gray
                                  : Color.primary
                          )
                      VStack(alignment: .leading) {
                        Text(chapter.attributes.title ?? "No Title")
                            .font(.headline)
                            .foregroundColor(
                                historyForMangaId?.chapterIds.contains(chapter.id.description) ?? false
                                    ? Color.gray
                                    : Color.primary
                            )
                        Text(getChapterScanlationGroupName(chapter: chapter))
                            .font(.subheadline)
                            .foregroundColor(
                                historyForMangaId?.chapterIds.contains(chapter.id.description) ?? false
                                    ? Color.gray
                                    : Color.primary
                            )
                      }
                      Spacer()
                      Image(systemName: "chevron.right")
                          .foregroundColor(
                              historyForMangaId?.chapterIds.contains(chapter.id.description) ?? false
                                  ? Color.gray
                                  : Color.primary
                          )
                    }
                    Divider()
                        .overlay(Color.gray)
                        .frame(height: 4)
                  }
                }
              }
              if showMoreButton {
                Button(action: {
                  offset += 1
                  fetchChapterResponse(mangaId: manga.id.description, offset: offset)
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
        }
      } else {
        ProgressView()
      }
    }
        .ignoresSafeArea(edges: .top)
        .onAppear() {
          if let manga = manga {
            fetchChapterResponse(mangaId: manga.id.description)
          } else {
            fetchManga(mangaId: mangaId)
            fetchChapterResponse(mangaId: mangaId)
          }
          historyForMangaId = history.first(where: { $0.mangaId == mangaId })
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button(action: {
          print("Favorite")
        }) {
          Image(systemName: "heart")
        })
  }

  func getChapterScanlationGroupName(chapter: Chapter) -> String {
    let chapterGroup = chapter.relationships.first(where: { $0.type == "scanlation_group" })
    return chapterGroup?.attributes?.name ?? "Unknown"
  }

  func fetchManga(mangaId: String) {
    let url = URL(string: "https://api.mangadex.org/manga/\(mangaId)?includes[]=cover_art")!
    let request = URLRequest(url: url)

    URLSession.shared.dataTask(with: request) { data, response, error in
      if let data = data {
        do {
          let mangaResponse = try JSONDecoder().decode(MangaResponse.self, from: data)
          DispatchQueue.main.async {
            self.manga = mangaResponse.data.first // Update your state variable here
          }
        } catch {
          print("Error decoding JSON: \(error)")
        }
      }
    }.resume()
  }

  func fetchChapterResponse(mangaId: String, offset: Int = 0) {
    let url = URL(string: "https://api.mangadex.org/manga/\(mangaId)/feed?translatedLanguage[]=en&order[chapter]=desc&limit=100&offset=\(offset*100)&contentRating[]=safe&contentRating[]=suggestive&contentRating[]=erotica&contentRating[]=pornographic&includes[]=scanlation_group")!
    let request = URLRequest(url: url)
    let semaphore = DispatchSemaphore(value: 0)
    var chapterResponse: ChapterResponse?

    URLSession.shared.dataTask(with: request) { data, response, error in
          if let data = data {
            do {
              chapterResponse = try JSONDecoder().decode(ChapterResponse.self, from: data)
              chapters?.append(contentsOf: chapterResponse?.data ?? [])
              print("Chapters: \(chapters?.count ?? 0) / \(chapterResponse?.total ?? 0)")
              if chapters?.count == chapterResponse?.total {
                showMoreButton = false
              }
              self.chaptersResponse = chapterResponse
            } catch {
              print("Error decoding JSON: \(error)")
            }
          }
          semaphore.signal()
        }.resume()
    semaphore.wait()
  }
}


