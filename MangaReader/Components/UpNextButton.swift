//
//  UpNextButton.swift
//  MangaReader
//
//  Created by Matthew Demers on 1/28/24.
//

import Foundation
import SwiftUI

struct VisualEffectBlur: UIViewRepresentable {
  var effect: UIVisualEffect?
  func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView {
    return UIVisualEffectView(effect: effect)
  }
  
  func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) {
    uiView.effect = effect
  }
}

struct UpNextButton: View {
  var manga: Manga
  var chapters: [Chapter]
  var history: History?
  
  @State var upNextChapter: Chapter? = nil
  
  var body: some View {
    VStack {
      if upNextChapter != nil {
        NavigationLink(destination: ChapterViewWrapper(
          totalChapters: chapters.count ,
          chapters: chapters,
          chapterId: upNextChapter?.id.description ?? "",
          mangaId: manga.id.description,
          mangaName: manga.attributes.title["en"] ?? "N/A",
          coverArtURL: manga.coverArt?.fullCoverURL ?? "N/A",
          isLongStrip: manga.attributes.tags?.contains(where: { $0.attributes.name["en"] == "Long Strip" }) ?? false
        )){
          HStack {
            // Icon for the button
            Image(systemName: "book.fill") // Replace with your preferred icon
              .foregroundColor(.white)
            
            VStack(alignment: .leading) {
              Text("Up Next")
                .font(.subheadline)
                .foregroundColor(.white)
              Text(
                upNextChapter?.attributes.title?.isEmpty == true || upNextChapter?.attributes.title == nil
                ? "Chapter \(upNextChapter!.attributes.chapter?.description ?? "N/A")"
                : upNextChapter!.attributes.title ?? "N/A")
              .font(.headline)
              .foregroundColor(.white)
            }
            Spacer()
          }
          .padding(8)
          .background(
            ZStack {
              VisualEffectBlur(effect: UIBlurEffect(style: .systemUltraThinMaterial))
              Color.purple.opacity(0.3)
                .cornerRadius(4)
            }
          )
        }
      }
    }
    .onAppear(){
      upNextChapter = getLatestChapter(chapters: chapters)
    }
    .onChange(of: chapters.count){
      upNextChapter = getLatestChapter(chapters: chapters)
    }
  }
  func getLatestChapter(chapters: [Chapter]) -> Chapter? {
    print("Chapter Count \(chapters.count)")
    
    // Sort chapters based on chapter number, putting non-numeric chapters at the end
    let sortedChapters = chapters.sorted { (chapter1, chapter2) -> Bool in
      // Try to convert chapter numbers to floats
      if let chapterNumber1 = Float(chapter1.attributes.chapter ?? ""),
         let chapterNumber2 = Float(chapter2.attributes.chapter ?? "") {
        return chapterNumber1 > chapterNumber2
      } else if let _ = Float(chapter1.attributes.chapter ?? "") {
        // Chapter 1 has a numeric chapter number, but Chapter 2 does not
        return true
      } else if let _ = Float(chapter2.attributes.chapter ?? "") {
        // Chapter 2 has a numeric chapter number, but Chapter 1 does not
        return false
      } else {
        // Both chapters have non-numeric chapter numbers, consider them equal
        return false
      }
    }
    
    // Filter chapters based on history
    if let history = history {
      let filteredChapters = sortedChapters.filter { chapter in
        !history.chapterIds.contains(chapter.id.description)
      }
      return filteredChapters.last ?? nil
    } else {
      return sortedChapters.last ?? nil
    }
  }
}

#Preview {
  UpNextButton(
    manga: MOCK_MANGA_OBJECT,
    chapters: MOCK_CHAPTERS,
    history: MOCK_HISTORY_ITEM
  )
}
