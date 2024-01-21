//
//  ChapterView.swift
//  Created by Matthew Demers on 12/1/23.
//

import Foundation
import SwiftUI
import SwiftData

struct ChapterView: View {
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
                if viewType == .singlePage {
                    SinglePageView(
                        orderedImages: orderedImages,
                        navigateToNextPage: goToNextChapter,
                        isIpad: false,
                        currentPage: $currentPage
                    )
                } else {
                    LongStripView(
                        orderedImages: orderedImages,
                        goToNextChapter: goToNextChapter,
                        goToLastChapter: goToLastChapter,
                        nextChapterId: nextChapterId,
                        lastChapterId: lastChapterId
                    )
                }
            }
        }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .onAppear {
                addChapterToHistory()
                viewType = isLongStrip ? .longStrip : .singlePage
                viewModel.fetchChapterData(chapterId: chapterId, dataType: dataType) { response in
                    self.atHomeResponse = response
                }
                if let nextChapterId = getNextChapter() {
                    self.nextChapterId = nextChapterId
                }
                if let lastChapterId = getLastChapter() {
                    self.lastChapterId = lastChapterId
                }
            }
            .navigationTitle(getChapterTitle())
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: HStack {
                ChapterMenu(viewType: $viewType, dataType: $dataType, clearAndRefetchData: clearAndRefetchChapterData)
            })

    }

    private func clearAndRefetchChapterData() {
        viewModel.fetchChapterData(chapterId: chapterId, dataType: dataType) { response in
            self.atHomeResponse = response
        }
    }

    private func getChapterTitle() -> String {
      guard let chapter = chapters.first(where: { $0.id.description == chapterId }) else { return "" }
      if isLongStrip {
        return "Chapter \(chapter.attributes.chapter ?? "Unknown")"
      }
      return "\(chapter.attributes.chapter ?? "Unknown") - \(currentPage+1)"
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
