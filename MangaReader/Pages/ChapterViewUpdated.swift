//
// Created by Matthew Demers on 12/28/23.
//

import Foundation
import SwiftUI
import SwiftData

struct ChapterViewUpdated: View {
  @Environment(\.modelContext) private var modelContext
  @Query private var history: [History]

  let totalChapters: Int
  let chapters: [Chapter]
  @State var chapterId: String = ""
  let mangaId: String
  let mangaName: String
  let coverArtURL: String
  let isLongStrip: Bool

  @StateObject var viewModel = ChapterViewUpdatedModel()
  @State var atHomeResponse: AtHomeResponse?
  @State var nextChapterId: String?
  @State var lastChapterId: String?
  @State var viewType: ViewType = .singlePage
  @State private var currentPage = 0
  @State private var dataType: DataTypes = .dataSaver


  var body: some View {
    VStack {
      if isLongStrip {
        longStripView
      } else {
        singlePageView
      }
    }
        .onAppear {
          viewModel.fetchChapterData(
              chapterId: chapterId,
              dataType: dataType
          ) { atHomeResponse in
            self.atHomeResponse = atHomeResponse
          }
        }
  }

  var longStripView: some View {
    ScrollView {
      LazyVStack {
        ForEach(viewModel.images.keys.sorted(by: { $0.absoluteString < $1.absoluteString }), id: \.self) { url in
          if let image = viewModel.images[url] {
            Image(uiImage: image ?? UIImage())
                .resizable()
                .aspectRatio(contentMode: .fit)
          } else {
            ProgressView()
          }
        }
      }
    }
        .onAppear {
          viewModel.loadImagesSequentially(
              atHomeResponse: atHomeResponse,
              dataType: dataType
          )
        }
  }

  var singlePageView: some View {
    VStack {
      if let atHomeResponse = atHomeResponse, viewModel.images.count > currentPage {
        let pageUrl = dataType == .data ? atHomeResponse.chapter.data[currentPage] :
            atHomeResponse.chapter.dataSaver[currentPage]
        let imageUrl = viewModel.getChapterUrl(atHomeResponse: atHomeResponse, pageUrl: pageUrl, dataType: dataType)

        if let image = viewModel.images[imageUrl] {
          Image(uiImage: image ?? UIImage())
              .resizable()
              .aspectRatio(contentMode: .fit)
        } else {
          ProgressView()
        }
      } else {
        Text("Loading...")
      }
      // Add controls for next and previous page
    }
        .gesture(DragGesture()
            .onEnded({ self.handleSwipe(translation: $0.translation.width) }))
        .onAppear {
          viewModel.loadCurrentNextLastImages(
              currentIndex: currentPage,
              atHomeResponse: atHomeResponse,
              dataType: dataType
          )
        }
        .onChange(of: currentPage) {
          viewModel.loadCurrentNextLastImages(
              currentIndex: currentPage,
              atHomeResponse: atHomeResponse,
              dataType: dataType
          )
        }
  }
  //UI functions
  private func handleSwipe(translation: CGFloat) {
    let swipeThreshold: CGFloat = 50
    if translation > swipeThreshold {
      currentPage = max(currentPage - 1, 0)
    } else if translation < -swipeThreshold {
      currentPage = min(currentPage + 1, viewModel.images.count - 1)
    }
  }
}
