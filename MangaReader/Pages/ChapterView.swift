//
//  ChapterView.swift
//  MangaReader
//
//  Created by Matthew Demers on 12/1/23.
//
import Foundation
import SwiftUI
import SwiftData

enum ViewType {
    case singlePage
    case longStrip
}

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
                    // Add average download speed in mb/s limit to 2 decimal places
                    Text("Average download speed: \(String(format: "%.2f", viewModel.averageDownloadSpeed / 1000000)) mb/s")
                        .font(.caption)
                        .foregroundColor(.gray)

                }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else {
                ScrollView {
                    if viewType == .singlePage {
                        singlePageView
                    } else {
                        longStripView
                    }
                }
            }
        }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .onAppear {
                addChapterToHistory()
                viewType = isLongStrip ? .longStrip : .singlePage
                viewModel.fetchChapterData(chapterId: chapterId) { response in
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
                ChapterMenu(viewType: $viewType)
            })
    }

    // Single Page View
    private var singlePageView: some View {
        VStack {
            let images = orderedImages()
            if currentPage < images.count {
                Image(uiImage: images[currentPage])
                    .resizable()
                    .scaledToFit()
                    .padding(0)
                    .onTapGesture(count: 2) {
                        goToNextPageOrChapter()
                    }
            }

            if !viewModel.isLoadingChapterData && viewModel.loadingProgress >= 1 {
                HStack {
                    Button(action: {
                        goToPreviousPageOrChapter()
                    }, label: {
                        Image(systemName: "chevron.left")
                        Text(currentPage <= 0 ? "Prev Chapter" : "Prev Page")
                    })
                        .buttonStyle(.bordered)
                        .disabled(lastChapterId == nil && currentPage == 0)
                    Spacer()
                    Button(action: {
                        goToNextPageOrChapter()
                    }, label: {
                        Text(currentPage >= images.count - 1 ? "Next Chapter" : "Next Page")
                        Image(systemName: "chevron.right")
                    })
                        .buttonStyle(.bordered)
                        .disabled(nextChapterId == nil && currentPage == images.count - 1)

                }
                    .padding()
                    .padding(.bottom, 10)
            }
        }
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
                            goToPreviousPageOrChapter()
                        }, label: {
                            Image(systemName: "chevron.left")
                            Text("Last Chapter")
                        })
                            .buttonStyle(.bordered)
                            .disabled(lastChapterId == nil)
                        Spacer()
                        Button(action: {
                            goToNextPageOrChapter()
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


    private func goToNextPageOrChapter() {
        if viewType == .singlePage {
            let totalPages = orderedImages().count 
            if currentPage < totalPages - 1 {
                currentPage += 1
            } else {
                goToNextChapter()
                currentPage = 0
            }
        } else {
            goToNextChapter()
        }
    }

    private func goToPreviousPageOrChapter() {
        if viewType == .singlePage {
            let totalPages = orderedImages().count 
            if currentPage > 0 {
                currentPage -= 1
            } else {
                goToLastChapter()
                currentPage = totalPages - 1
            }
        } else {
            goToLastChapter()
        }
    }

    private func orderedImages() -> [UIImage] {
        guard let atHomeResponse = self.atHomeResponse else { return [] }

        return atHomeResponse.chapter.data.compactMap { pageUrl -> UIImage? in
            let url = getChapterUrl(atHomeResponse: atHomeResponse, chapterId: pageUrl)
            return viewModel.images[url] ?? nil
        }
    }

    private func getLastChapter() -> String? {
        guard let index = chapters.firstIndex(where: { $0.id.description == chapterId }) else { return nil }
        if index == chapters.count - 1 { return nil }
        let nextChapter = chapters[index + 1]
        let nextChapterId = nextChapter.id.description
        viewModel.clearImages()
        return nextChapterId
    }

    private func getNextChapter() -> String? {
        guard let index = chapters.firstIndex(where: { $0.id.description == chapterId }) else { return nil }
        if index == 0 { return nil }
        let lastChapter = chapters[index - 1]
        let lastChapterId = lastChapter.id.description
        viewModel.clearImages()
        return lastChapterId
    }

    private func goToNextChapter() {
        guard let nextChapterId = nextChapterId else { return }
        self.chapterId = nextChapterId
        self.nextChapterId = getNextChapter()
        self.lastChapterId = getLastChapter()
        addChapterToHistory()
        viewModel.fetchChapterData(chapterId: chapterId) { response in
            self.atHomeResponse = response
        }
    }

    private func goToLastChapter() {
        guard let lastChapterId = lastChapterId else { return }
        self.chapterId = lastChapterId
        self.nextChapterId = getNextChapter()
        self.lastChapterId = getLastChapter()
        addChapterToHistory()
        viewModel.fetchChapterData(chapterId: chapterId) { response in
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
        try! modelContext.insert(history)
    }
}
