//
//  ChapterView.swift
//  MangaReader
//
//  Created by Matthew Demers on 12/1/23.
//
import Foundation
import SwiftUI
import SwiftData

struct ChapterView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var history: [History]

    let chapters: [Chapter]
    @State var chapterId: String = ""
    let mangaId: String
    let mangaName: String

    @StateObject var viewModel = ChapterViewModel()
    @State var atHomeResponse: AtHomeResponse?
    @State var nextChapterId: String?
    @State var lastChapterId: String?

    var body: some View {
        ScrollView {
            VStack {
                if viewModel.isLoadingChapterData {
                    Text("Fetching chapter data...")
                } else if viewModel.loadingProgress < 1 {
                    ProgressView(value: viewModel.loadingProgress)
                        .progressViewStyle(LinearProgressViewStyle())
                } else {
                    ForEach(orderedImages(), id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                    }
                }
                // Add buttons to go to next/last chapter
                HStack {
                    if lastChapterId != nil {
                        Button(action: {
                            goToLastChapter()
                        }, label: {
                            Text("Last Chapter")
                        })
                    }
                    Spacer()
                    if nextChapterId != nil {
                        Button(action: {
                            goToNextChapter()
                        }, label: {
                            Text("Next Chapter")
                        })
                    }
                }
            }
        }
            .onAppear {
                addChapterToHistory()
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
            })
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
        print("Next chapter id: \(nextChapterId)")
        return nextChapterId
    }

    private func getNextChapter() -> String? {
        guard let index = chapters.firstIndex(where: { $0.id.description == chapterId }) else { return nil }
        if index == 0 { return nil }
        let lastChapter = chapters[index - 1]
        let lastChapterId = lastChapter.id.description
        print("Last chapter id: \(lastChapterId)")
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
            return
        }
        let history = History(mangaId: mangaId, mangaName: mangaName, totalChapters: chapters.count, chapterIds: [chapterId], lastRead: Date(), lastReadChapterId: chapterId)
        try! modelContext.insert(history)
    }
}
