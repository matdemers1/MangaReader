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
  @Binding var sortDirection: OrderDirection
  let historyForMangaId: History?
  let manga: Manga
  let reload: () -> Void
  @StateObject var viewModel = MangaDetailViewModel()
  @State var chaptersString = ""
  @State private var isLoading = true

  
  func getChapterString(chapters: [Chapter]) -> String {
    // Sort the chapters by their chapter number in ascending order and remove duplicates
    // create a list of all chapter ids
    let chapterIds = chapters.map { $0.attributes.chapter }
    let sortedUniqueChapters = chapters
      .compactMap { chapter -> Int? in
        guard let chapterStr = chapter.attributes.chapter, let chapterNum = Int(chapterStr) else { return nil }
        return chapterNum
      }
      .sorted()
      .reduce(into: [Int]()) { result, chapterNum in
        if result.last != chapterNum {
          result.append(chapterNum)
        }
      }
    
    var chapterString = ""
    var startChapter = 0
    var endChapter = 0
    for (index, chapterNum) in sortedUniqueChapters.enumerated() {
      if index == 0 {
        startChapter = chapterNum
        endChapter = chapterNum
      } else {
        if chapterNum == endChapter + 1 {
          endChapter = chapterNum
        } else {
          if startChapter == endChapter {
            chapterString += "\(startChapter), "
          } else {
            chapterString += "\(startChapter)-\(endChapter), "
          }
          startChapter = chapterNum
          endChapter = chapterNum
        }
      }
    }
    // Handle the last range or single chapter
    if startChapter == endChapter {
      chapterString += "\(startChapter)"
    } else {
      chapterString += "\(startChapter)-\(endChapter)"
    }
    return chapterString.trimmingCharacters(in: .whitespacesAndNewlines)
  }


  var body: some View {
    VStack(alignment: .leading) {
      HStack{
        Text("Chapters")
          .font(.subheadline)
          .padding(.bottom, 0)
        Spacer()
        Text ("Sorting:")
          .font(.subheadline)
          .padding(.bottom, 0)
        Picker("", selection: $sortDirection) {
          ForEach(OrderDirection.allCases, id: \.self) { direction in
            Text(direction.description)
              .font(.subheadline)
              .padding(.bottom, 0)
          }
        }.onChange(of: sortDirection) {
          reload()
        }
        .padding(0)
      }
      .padding(.bottom, 0)
      HStack {
        Text("Chapter List:")
          .font(.subheadline)
          .padding(.bottom, 4)
        if isLoading {
          Text("Loading...")
            .font(.subheadline)
            .padding(.bottom, 4)
        } else if let chapters = chapters, !chapters.isEmpty {
          Text(chaptersString)
            .font(.subheadline)
            .padding(.bottom, 4)
        } else {
          Text("No chapters available")
            .font(.subheadline)
            .padding(.bottom, 4)
        }
      }
      .onAppear {
        if chapters == nil || chapters!.isEmpty {
          isLoading = true
          // Simulate a data fetch
          DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // Simulate async load
            // Assume chapters are now loaded
            isLoading = false
            if let loadedChapters = chapters, !loadedChapters.isEmpty {
              chaptersString = getChapterString(chapters: loadedChapters)
            }
          }
        } else {
          isLoading = false
          chaptersString = getChapterString(chapters: chapters!)
        }
      }
      Divider()
        .overlay(Color.gray)
        .frame(height: 4)
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
                chaptersResponse: $chaptersResponse,
                sort: sortDirection
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

var boolHander : () -> Void = {  }
#Preview {
  ScrollView{
    ChapterListSection(
      chapters: .constant(MOCK_CHAPTERS.reversed()),
      offset: .constant(0),
      showMoreButton: .constant(false),
      chaptersResponse: .constant(ChapterResponse(
        result: "200 OK",
        response: "200 OK",
        data: MOCK_CHAPTERS,
        limit: 999,
        offset: 0,
        total: 10
      )),
      sortDirection: .constant(OrderDirection.desc),
      historyForMangaId: nil,
      manga: MOCK_MANGA_OBJECT,
      reload: boolHander
    )
  }
}
