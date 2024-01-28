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
  @State private var sortDirection: OrderDirection = .desc
  @Query var history: [History]
  @Query var readingListGroups: [ReadingListGroup]
  
  @StateObject var viewModel = MangaDetailViewModel()
  private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
  
  var body: some View {
    GeometryReader { geometry in
      let isLandscape = geometry.size.width > geometry.size.height
      let isiPad = idiom == .pad
      
      if let manga = manga {
        if isiPad && isLandscape {
          HStack {
            MangaDetailSection(
              manga: manga,
              chapters: chapters ?? [],
              history: historyForMangaId
            )
            .frame(height: geometry.size.height)
            Divider()
            ScrollView {
              ChapterListSection(
                chapters: $chapters,
                offset: $offset,
                showMoreButton: $showMoreButton,
                chaptersResponse: $chaptersResponse,
                sortDirection: $sortDirection,
                historyForMangaId: historyForMangaId,
                manga: manga,
                reload: reload
              )
            }
          }
        } else {
          ScrollView {
            VStack {
              MangaDetailSection(
                manga: manga,
                chapters: chapters ?? [],
                history: historyForMangaId
              )
              SuggestionsContainer(manga: manga)
              ChapterListSection(
                chapters: $chapters,
                offset: $offset,
                showMoreButton: $showMoreButton,
                chaptersResponse: $chaptersResponse,
                sortDirection: $sortDirection,
                historyForMangaId: historyForMangaId,
                manga: manga,
                reload: reload
              )
            }
          }
        }
      } else {
        ProgressView()
          .scaleEffect(1.5, anchor: .center)
          .progressViewStyle(CircularProgressViewStyle(tint: .primary))
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
            chaptersResponse: $chaptersResponse,
            sort: sortDirection
          )
        } else {
          viewModel.fetchManga(mangaId: mangaId, manga: $manga)
          viewModel.fetchChapterResponse(
            mangaId: mangaId,
            chapters: $chapters,
            showMoreButton: $showMoreButton,
            chaptersResponse: $chaptersResponse,
            sort: sortDirection
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
  
  func reload() {
    chaptersResponse = nil
    chapters = []
    offset = 0
    viewModel.fetchChapterResponse(
      mangaId: mangaId,
      chapters: $chapters,
      showMoreButton: $showMoreButton,
      chaptersResponse: $chaptersResponse,
      sort: sortDirection
    )
  }
}

#Preview {
  MangaDetailView(
    mangaId: "348966d0-c807-45cf-9260-8adf006a9da6"
  )
}
