//
//  MangaDetailView.swift
//  MangaReader
//
//  Created by Matthew Demers on 11/28/23.
//

import Foundation
import SwiftUI

struct MangaDetailView: View {
  let manga: Manga
  let chaptersResponse: ChapterResponse?
  let chapters: [Chapter]?

  init(manga: Manga) {
    self.manga = manga
    self.chaptersResponse = fetchChapterResponse(mangaId: manga.id.description)
    self.chapters = chaptersResponse?.data
  }

  var body: some View {
    ScrollView() {
      VStack(spacing: 0) {
        ZStack(alignment:.bottomLeading){
          GeometryReader { geometry in
            if let coverArtURL = manga.coverArt?.fullCoverURL {
              AsyncImage(url: URL(string: coverArtURL)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width)
                    .frame(height: geometry.size.height/1)
              } placeholder: {
                ProgressView()
              }
            }
          }
          LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom)
              .frame(height: 480)

          // Title and Artist name
          VStack(alignment: .leading){
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
        VStack(alignment: .leading){
          Text("Chapters")
              .font(.subheadline)
              .padding(.bottom, 4)
          if let chapters = chapters {
            ForEach(chapters, id: \.id){ chapter in
              NavigationLink(destination: ChapterView(chapters: chapters, chapterId: chapter.id.description ?? "N/A")) {
                VStack {
                  HStack(alignment: .center) {
                    Text(chapter.attributes.chapter ?? "N/A")
                        .font(.headline)
                        .foregroundColor(Color.primary)
                    VStack(alignment: .leading) {
                      Text(chapter.attributes.title ?? "No Title")
                          .font(.headline)
                          .foregroundColor(Color.primary)
                      Text(getChapterScanlationGroupName(chapter: chapter))
                          .font(.subheadline)
                          .foregroundColor(Color.primary)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color.primary)
                  }
                  Divider()
                      .overlay(Color.gray)
                      .frame(height: 4)
                }
              }
            }
          } else {
            Text("No chapters available")
          }
        }
            .frame(maxWidth: .infinity)
            .padding()
      }
    }
        .ignoresSafeArea(edges: .top)
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
}

func fetchChapterResponse(mangaId: String) -> ChapterResponse? {
  let url = URL(string: "https://api.mangadex.org/manga/\(mangaId)/feed?translatedLanguage[]=en&order[chapter]=desc&limit=100&includes[]=scanlation_group")!
  let request = URLRequest(url: url)
  let semaphore = DispatchSemaphore(value: 0)
  var chapterResponse: ChapterResponse?

  URLSession.shared.dataTask(with: request) { data, response, error in
    if let data = data {
      do {
        chapterResponse = try JSONDecoder().decode(ChapterResponse.self, from: data)
      } catch {
        print("Error decoding JSON: \(error)")
      }
    }
    semaphore.signal()
  }.resume()
  semaphore.wait()

  return chapterResponse
}

#Preview {
  MangaDetailView(manga: loadMockSingleData())
      .modelContainer(for: Item.self, inMemory: true)
      .colorScheme(.dark)
}

