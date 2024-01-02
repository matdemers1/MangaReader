//
// Created by Matthew Demers on 1/1/24.
//

import Foundation
import SwiftUI

struct LongStripView: View {
  @StateObject var viewModel = ChapterViewModel()
  var orderedImages: () -> [UIImage]
  var goToNextChapter: () -> Void
  var goToLastChapter: () -> Void
  var nextChapterId: String?
  var lastChapterId: String?


  var body: some View {
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
}