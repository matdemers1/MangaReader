//
//  ChapterView.swift
//  MangaReader
//
//  Created by Matthew Demers on 12/1/23.
//
import Foundation
import SwiftUI

struct ChapterView: View {
    @StateObject var viewModel = ChapterViewModel()
    let chapterId: String
    @State var atHomeResponse: AtHomeResponse?

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
            }
        }
            .onAppear {
                viewModel.fetchChapterData(chapterId: chapterId) { response in
                    self.atHomeResponse = response
                }
            }
    }

    private func orderedImages() -> [UIImage] {
        guard let atHomeResponse = self.atHomeResponse else { return [] }

        return atHomeResponse.chapter.data.compactMap { pageUrl -> UIImage? in
            let url = getChapterUrl(atHomeResponse: atHomeResponse, chapterId: pageUrl)
            return viewModel.images[url] ?? nil
        }
    }
}
