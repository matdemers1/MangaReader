//
// Created by Matthew Demers on 1/1/24.
//

import Foundation
import SwiftUI

struct ChapterViewWrapper: View {
  private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }

  var totalChapters: Int
  var chapters: [Chapter]
  var chapterId: String
  var mangaId: String
  var mangaName: String
  var coverArtURL: String
  var isLongStrip: Bool

  var body: some View {
    GeometryReader { geometry in
      let isLandscape = geometry.size.width > geometry.size.height
      let isiPad = idiom == .pad

      if isiPad {
        iPadChapterView(
            totalChapters: totalChapters,
            chapters: chapters,
            chapterId: chapterId,
            mangaId: mangaId,
            mangaName: mangaName,
            coverArtURL: coverArtURL,
            isLongStrip: isLongStrip,
            isLandscape: isLandscape
        )
      } else {
        ChapterView(
            totalChapters: totalChapters,
            chapters: chapters,
            chapterId: chapterId,
            mangaId: mangaId,
            mangaName: mangaName,
            coverArtURL: coverArtURL,
            isLongStrip: isLongStrip
        )
      }
    }
  }
}