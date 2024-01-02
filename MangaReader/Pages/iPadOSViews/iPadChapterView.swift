//
// Created by Matthew Demers on 1/1/24.
//

import Foundation
import SwiftUI
import SwiftData

struct iPadChapterView: View {
  @Environment(\.modelContext) private var modelContext
  @Query private var history: [History]

  let totalChapters: Int
  let chapters: [Chapter]
  @State var chapterId: String = ""
  let mangaId: String
  let mangaName: String
  let coverArtURL: String
  let isLongStrip: Bool

  @StateObject var viewModel = ChapterViewModel()
  @State var atHomeResponse: AtHomeResponse?
  @State var nextChapterId: String?
  @State var lastChapterId: String?
  @State var viewType: ViewType = .singlePage
  @State private var currentPage = 0
  @State private var dataType: DataTypes = .dataSaver

  var body: some View {
    NavigationView {
      iPadChapterSidebar(
          chapters: chapters,
          dataType: $dataType,
          chapterId: $chapterId,
          refetch: clearAndRefetchChapterData
      )
      VStack {
        if viewModel.isLoadingChapterData {
          Text("Fetching chapter data...")
        } else if viewModel.errorMessage != nil {
          VStack {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.red)
            Text("Error fetching chapter data")
                .font(.headline)
                .foregroundColor(.red)
            Text(viewModel.errorMessage!)
                .font(.caption)
                .foregroundColor(.red)
          }
              .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

        } else if viewModel.loadingProgress < 1 {
          VStack {
            Text("Loading images...")
                .font(.headline)
                .foregroundColor(.gray)
            ProgressView(value: viewModel.loadingProgress)
                .tint(.purple)

            Text("Pages loaded: \(viewModel.totalPagesLoaded)")
                .font(.caption)
                .foregroundColor(.gray)
          }
              .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        } else {
          if isLongStrip {
            LongStripView(
                orderedImages: orderedImages,
                goToNextChapter: goToNextChapter,
                goToLastChapter: goToLastChapter,
                nextChapterId: nextChapterId,
                lastChapterId: lastChapterId
            )
          } else {
            SinglePageView(
                orderedImages: orderedImages,
                navigateToNextPage: goToNextChapter
            )
          }
        }
      }
          .onAppear {
            viewModel.fetchChapterData(
                chapterId: chapterId,
                dataType: dataType
            ) { atHomeResponse in
              self.atHomeResponse = atHomeResponse
            }
            addChapterToHistory()
          }
    }
  }

  private func clearAndRefetchChapterData() {
    viewModel.fetchChapterData(chapterId: chapterId, dataType: dataType) { response in
      self.atHomeResponse = response
    }
  }

  private func orderedImages() -> [UIImage] {
    guard let atHomeResponse = self.atHomeResponse else { return [] }

    if dataType == .data {
      return atHomeResponse.chapter.data.compactMap { pageUrl -> UIImage? in
        let url = viewModel.getChapterUrl(atHomeResponse: atHomeResponse, pageUrl: pageUrl, dataType: dataType)
        return viewModel.images[url] ?? nil
      }
    } else {
      return atHomeResponse.chapter.dataSaver.compactMap { pageUrl -> UIImage? in
        let url = viewModel.getChapterUrl(atHomeResponse: atHomeResponse, pageUrl: pageUrl, dataType: dataType)
        return viewModel.images[url] ?? nil
      }
    }
  }

  private func getLastChapter() -> String? {
    guard let index = chapters.firstIndex(where: { $0.id.description == chapterId }) else { return nil }
    if index == chapters.count - 1 { return nil }
    let nextChapter = chapters[index + 1]
    let nextChapterId = nextChapter.id.description
    return nextChapterId
  }

  private func getNextChapter() -> String? {
    guard let index = chapters.firstIndex(where: { $0.id.description == chapterId }) else { return nil }
    if index == 0 { return nil }
    let lastChapter = chapters[index - 1]
    let lastChapterId = lastChapter.id.description
    return lastChapterId
  }

  private func goToNextChapter() {
    guard let nextChapterId = nextChapterId else { return }
    self.chapterId = nextChapterId
    self.nextChapterId = getNextChapter()
    self.lastChapterId = getLastChapter()
    addChapterToHistory()
    viewModel.fetchChapterData(chapterId: chapterId, dataType: dataType) { response in
      self.atHomeResponse = response
    }
  }

  private func goToLastChapter() {
    guard let lastChapterId = lastChapterId else { return }
    self.chapterId = lastChapterId
    self.nextChapterId = getNextChapter()
    self.lastChapterId = getLastChapter()
    addChapterToHistory()
    viewModel.fetchChapterData(chapterId: chapterId, dataType: dataType) { response in
      self.atHomeResponse = response
    }
  }

  private func addChapterToHistory() {
    if let history = history.first(where: { $0.mangaId == mangaId }) {
      if !history.chapterIds.contains(chapterId) {
        history.chapterIds.append(chapterId)
      }
      history.lastReadChapterId = chapterId
      history.lastRead = Date()
      history.coverArtURL = coverArtURL
      return
    }
    let history = History(
        mangaId: mangaId,
        mangaName: mangaName,
        totalChapters: totalChapters,
        chapterIds: [chapterId],
        lastRead: Date(),
        lastReadChapterId: chapterId,
        coverArtURL: coverArtURL
    )
    modelContext.insert(history)
  }
}