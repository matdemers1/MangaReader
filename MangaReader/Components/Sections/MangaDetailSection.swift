//
// Created by Matthew Demers on 12/26/23.
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

struct MangaDetailSection: View {
  var manga: Manga
  var chapters: [Chapter]
  var history: History?
  
  @State var upNextChapter: Chapter? = nil
  
  var body: some View {
    VStack(spacing: 0) {
      ZStack(alignment: .bottomLeading) {
        GeometryReader { geometry in
          if let coverArtURL = manga.coverArt?.fullCoverURL {
            AsyncImage(url: URL(string: coverArtURL)) { image in
              image
                .resizable()
                .scaledToFill()
                .frame(width: geometry.size.width)
            } placeholder: {
              ProgressView()
            }
          }
        }
        LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom)
          .frame(height: 480)
        
        // Title and Artist name
        VStack(alignment: .leading) {
          Text(manga.attributes.title["en"] ?? "Unknown Title")
            .font(.title2)
            .foregroundColor(.white)
            .padding(.top, 20)
          HStack {
            Text("Manga Id")
              .font(.body)
              .foregroundColor(.secondary)
            // Add Copy button
            Button {
              UIPasteboard.general.string = manga.id
            } label: {
              Image(systemName: "doc.on.doc")
            }
          }
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
                  // Title of the next chapter
                  Text(
                    upNextChapter?.attributes.title?.isEmpty == true || upNextChapter?.attributes.title == nil
                    ? "Chapter \(upNextChapter!.attributes.chapter?.description ?? "N/A")"
                    : upNextChapter!.attributes.title ?? "N/A")
                  .font(.headline)
                  .foregroundColor(.white)
                  
                  // Descriptive text
                  Text("Up Next")
                    .font(.subheadline)
                    .foregroundColor(.white)
                }
                
                Spacer()
              }
              .padding()
              .background(
                ZStack {
                  VisualEffectBlur(effect: UIBlurEffect(style: .systemUltraThinMaterial))
                  Color.purple.opacity(0.3)
                }
                  .cornerRadius(8)
              )
              .cornerRadius(8)
              .padding(.horizontal)
            }
          }
        }
        .padding()
        
      }
      // Manga Details
      VStack(alignment: .leading, spacing: 8) {
        ExpandableText(manga.attributes.description?["en"] ?? "No description", lineLimit: 6)
          .foregroundColor(.white)
          .padding()
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .background(Color.black)
      .onAppear(){
        upNextChapter = getLatestChapter(chapters: chapters)
      }
      .onChange(of: chapters.count){
        upNextChapter = getLatestChapter(chapters: chapters)
      }
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
  MangaDetailSection(
    manga: MOCK_MANGA_OBJECT,
    chapters: MOCK_CHAPTERS,
    history: MOCK_HISTORY_ITEM
  )
}
