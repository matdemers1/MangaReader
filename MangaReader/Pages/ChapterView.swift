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
                        navigateToNextPage: goToNextChapter
                    )
                } else {
                    longStripView
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
            .navigationBarItems(trailing: HStack {
                Button(action: {
                    goToLastChapter()
                }, label: {
                    Image(systemName: "chevron.left")
                })
                    .disabled(lastChapterId == nil)
                Button(action: {
                    goToNextChapter()
                }, label: {
                    Image(systemName: "chevron.right")
                })
                    .disabled(nextChapterId == nil)
                ChapterMenu(viewType: $viewType, dataType: $dataType, clearAndRefetchData: clearAndRefetchChapterData)
            })
    }


    private var longStripView: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(orderedImages(), id: \.self) { image in
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .padding(0)
                        .onTapGesture(count: 2) {
                            goToNextChapter()
                        }
                }
                if !viewModel.isLoadingChapterData && viewModel.loadingProgress >= 1 {
                    HStack {
                        Button(action: {
                            goToLastChapter()
                        }, label: {
                            Image(systemName: "chevron.left")
                            Text("Last Chapter")
                        })
                            .buttonStyle(.bordered)
                            .disabled(lastChapterId == nil)
                        Spacer()
                        Button(action: {
                            goToNextChapter()
                        }, label: {
                            Image(systemName: "chevron.right")
                            Text("Next Chapter")
                        })
                            .buttonStyle(.bordered)
                            .disabled(nextChapterId == nil)
                    }
                        .padding()
                        .padding(.bottom, 10)
                }
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
