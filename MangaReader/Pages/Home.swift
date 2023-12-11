//
//  Home.swift
//  MangaReader
//
//  Created by Matthew Demers on 11/28/23.
//

import Foundation
import SwiftUI

struct HomeView: View {
  @State private var mangas: [Manga] = []
  @State private var page: Int = 1
  @State private var isLoading: Bool = false

  var body: some View {
    NavigationStack{
      ZStack {
        if !mangas.isEmpty{
          ScrollView {
            LazyVStack {
              ForEach(mangas, id: \.id) { manga in
                MangaCardView(manga: manga)
              }
              Button(action: loadMoreMangas) {
                Text("Load more")
              }
            }
          }
              .padding(.horizontal, 8)
        }

        if isLoading {
          ProgressView()
              .scaleEffect(1.5, anchor: .center)
              .progressViewStyle(CircularProgressViewStyle(tint: .primary))
        }
      }
          .navigationTitle("Home")
    }
        .onAppear() {
          if mangas.isEmpty {
            loadInitialMangas()
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
}


func fetchHomePage(page: Int, completion: @escaping ([Manga]) -> Void) {
  print("Fetching page \(page)")
  let url = URL(string: "https://api.mangadex.org/manga?includes[]=cover_art&offset=\(page*10)&limit=10")!
  let request = URLRequest(url: url)

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

