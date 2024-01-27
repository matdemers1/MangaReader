//
//  Home.swift
//  MangaReader
//
//  Created by Matthew Demers on 11/28/23.
//

import Foundation
import SwiftUI
import SwiftData

struct HomeView: View {
  @Query private var accountSettings: [Account]
  @Query(sort: \History.lastRead, order: .reverse) private var historyItems: [History]

  @State private var mangas: [Manga] = []
  @State private var page: Int = 1
  @State private var isLoading: Bool = false

  var body: some View {
    NavigationStack {
      GeometryReader { geometry in
        VStack {
          HStack {
            Text("Home")
                .font(.largeTitle.bold())
                .padding()
          }
              .frame(maxWidth: .infinity, alignment: .leading)
          ScrollView {
            LazyVStack(alignment: .leading, spacing: 8, pinnedViews: [.sectionHeaders]) {
              if historyItems.count > 0 {
                Section {
                  ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                      ForEach(historyItems.prefix(10)) { historyItem in
                        MangaHistoryCard(
                          mangaId: historyItem.mangaId,
                          coverArtUrl: historyItem.coverArtURL,
                          mangaName: historyItem.mangaName,
                          lastRead: historyItem.lastRead
                        )
                      }
                    }
                        .padding(.horizontal, 8)
                  }
                } header: {
                  Text("Continue Reading")
                      .font(.headline)
                      .padding(.top, 8)
                      .padding(.horizontal, 8)
                      .frame(maxWidth: .infinity, alignment: .leading)
                      .background(Color(.systemBackground))
                }
              }
              DiscoverSection(mangas: mangas, loadMoreMangas: loadMoreMangas, geometry: geometry)
            }
          }

          if isLoading {
            ProgressView()
                .scaleEffect(1.5, anchor: .center)
                .progressViewStyle(CircularProgressViewStyle(tint: .primary))
          }
        }
            .onAppear() {
              if mangas.isEmpty {
                loadInitialMangas()
              }
            }
      }
    }
  }

  private func loadInitialMangas() {
    isLoading = true
    fetchHomePage(page: 1) { mangas in
      self.mangas = mangas
      self.isLoading = false
    }
  }

  private func loadMoreMangas() {
    page += 1
    fetchHomePage(page: page) { newMangas in
      self.mangas.append(contentsOf: newMangas)
    }
  }

  func fetchHomePage(page: Int, completion: @escaping ([Manga]) -> Void) {
    let allowAdultContent = accountSettings.first?.showAdultContent ?? false
    let language = accountSettings.first?.isTranslatedTo ?? Languages.english.rawValue

    var url = URLComponents(string: "https://api.mangadex.org/manga")!

    var queryItems: [URLQueryItem] = []
    queryItems.append(URLQueryItem(name: "limit", value: "20"))
    queryItems.append(URLQueryItem(name: "offset", value: String(page * 20)))
    queryItems.append(URLQueryItem(name: "includes[]", value: "cover_art"))
    // if allowAdultContent is true, loop through the contentRating array and add each value to the queryItems
    if allowAdultContent {
      for rating in ContentRating.allCases {
        queryItems.append(URLQueryItem(name: "contentRating[]", value: rating.rawValue))
      }
    }
    if language != Languages.all.description {
      queryItems.append(URLQueryItem(name: "availableTranslatedLanguage[]", value: language))
    }
    url.queryItems = queryItems

    let request = URLRequest(url: url.url!)

    URLSession.shared.dataTask(with: request) { data, response, error in
          var mangas: [Manga] = []
          if let data = data {
            let decoder = JSONDecoder()
            let mangaResponse = try? decoder.decode(MangaResponse.self, from: data)
            mangas = mangaResponse?.data ?? []
          }
          DispatchQueue.main.async {
            completion(mangas)
          }
        }.resume()
  }
}




