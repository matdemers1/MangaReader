//
//  MangaDetailView.swift
//  MangaReader
//
//  Created by Matthew Demers on 11/28/23.
//

import Foundation
import SwiftUI
import SwiftData

struct MangaDetailView: View {
  @State var manga: Manga? = nil
  @State var mangaId: String = ""
  @State var chaptersResponse: ChapterResponse?
  @State var chapters: [Chapter]? = []
  @State var offset = 0
  @State var showMoreButton = true
  @State var historyForMangaId: History? = nil
  @State var showAddToGroup = false
  @State var selectedGroup: UUID? = nil
  @Query var history: [History]
  @Query var readingListGroups: [ReadingListGroup]

  @StateObject var viewModel = MangaDetailViewModel()
  private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }

  var body: some View {
    GeometryReader { geometry in
      let isLandscape = geometry.size.width > geometry.size.height
      let columnsCount = idiom == .pad && isLandscape ? 2 : 1
      let columns: [GridItem] = Array(repeating: .init(.flexible()), count: columnsCount)

      ScrollView() {
        if let manga = manga {
          LazyVGrid(columns: columns, spacing: 10) {
            MangaDetailSection(manga: manga)
            VStack(alignment: .leading) {
              Text("Chapters")
                  .font(.subheadline)
                  .padding(.bottom, 4)
              if let chapters = chapters {
                ForEach(chapters, id: \.id) { chapter in
                  NavigationLink(destination: ChapterViewUpdated(
                      totalChapters: chaptersResponse?.total ?? 0,
                      chapters: chapters,
                      chapterId: chapter.id.description,
                      mangaId: manga.id.description,
                      mangaName: manga.attributes.title["en"] ?? "N/A",
                      coverArtURL: manga.coverArt?.fullCoverURL ?? "N/A",
                      isLongStrip: manga.attributes.tags?.contains(where: { $0.attributes.name["en"] == "Long Strip" }) ?? false
                  )) {
                    VStack {
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
                      Divider()
                          .overlay(Color.gray)
                          .frame(height: 4)
                    }
                  }
                }
                if showMoreButton {
                  Button(action: {
                    offset += 1
                    viewModel.fetchChapterResponse(
                        mangaId: manga.id.description,
                        offset: offset,
                        chapters: $chapters,
                        showMoreButton: $showMoreButton,
                        chaptersResponse: $chaptersResponse
                    )
                  }) {
                    Text("Load more chapters")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                  }
                }
              } else {
                Text("No chapters available")
              }
            }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.systemBackground))
          }
        } else {
          ProgressView()
        }
      }
          .ignoresSafeArea(edges: .top)
          .onAppear() {
            if chapters?.count == 0 {
              if let manga = manga {
                viewModel.fetchChapterResponse(
                    mangaId: manga.id.description,
                    chapters: $chapters,
                    showMoreButton: $showMoreButton,
                    chaptersResponse: $chaptersResponse
                )
              } else {
                viewModel.fetchManga(mangaId: mangaId, manga: $manga)
                viewModel.fetchChapterResponse(
                    mangaId: mangaId,
                    chapters: $chapters,
                    showMoreButton: $showMoreButton,
                    chaptersResponse: $chaptersResponse
                )
              }
              historyForMangaId = history.first(where: { $0.mangaId == mangaId })
            }
          }
          .navigationBarTitleDisplayMode(.inline)
          .navigationBarItems(trailing: Button(action: {
            showAddToGroup.toggle()
          }) {
            Image(systemName: "heart")
          }
              .sheet(isPresented: $showAddToGroup) {
                VStack {
                  Text("Add to Group")
                      .font(.title)
                      .padding([.top, .leading, .trailing])
                      .frame(maxWidth: .infinity, alignment: .leading)
                  Picker("Reading List Group", selection: $selectedGroup) {
                    ForEach(readingListGroups, id: \.groupId) { group in
                      Text(group.groupName).tag(group.groupId as UUID?)
                    }
                  }
                      .pickerStyle(.wheel)
                  Button("Add to Group") {
                    viewModel.addMangaToReadingList(
                        selectedGroup: selectedGroup ?? UUID(),
                        mangaId: mangaId,
                        manga: manga,
                        readingListGroups: readingListGroups
                    )
                    showAddToGroup.toggle()
                  }
                      .padding([.bottom])
                      .frame(maxWidth: .infinity)
                }
                    .presentationDetents([.height(300)])
              }
          )
    }
  }
}


