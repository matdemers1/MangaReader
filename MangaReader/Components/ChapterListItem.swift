//
// Created by Matthew Demers on 1/1/24.
//

import Foundation
import SwiftUI

struct ChapterListItem: View {
  var chapter: Chapter
  var historyForMangaId: History?
  @StateObject var viewModel = MangaDetailViewModel()

  var body: some View {
    HStack(alignment: .center) {
      Text(chapter.attributes.chapter ?? "N/A")
          .font(.headline)
          .foregroundColor(
              historyForMangaId?.chapterIds.contains(chapter.id.description) ?? false
                  ? Color.gray
                  : Color.primary
          )
      VStack(alignment: .leading) {
        Text(chapter.attributes.title ?? "No Title")
            .font(.headline)
            .foregroundColor(
                historyForMangaId?.chapterIds.contains(chapter.id.description) ?? false
                    ? Color.gray
                    : Color.primary
            )
        if let group = viewModel.getChapterScanlationGroup(chapter: chapter) {
          NavigationLink(destination: ScanlationGroupView(groupData: group)) {
            Text(group.name ?? "No Group")
                .font(.subheadline)
                .foregroundColor(
                    historyForMangaId?.chapterIds.contains(chapter.id.description) ?? false
                        ? Color.gray
                        : Color.accentColor
                )
          }
        } else {
          Text("No Group")
              .font(.subheadline)
              .foregroundColor(
                  historyForMangaId?.chapterIds.contains(chapter.id.description) ?? false
                      ? Color.gray
                      : Color.primary
              )
        }
      }
      Spacer()
      Image(systemName: "chevron.right")
          .foregroundColor(
              historyForMangaId?.chapterIds.contains(chapter.id.description) ?? false
                  ? Color.gray
                  : Color.primary
          )
    }
  }
}