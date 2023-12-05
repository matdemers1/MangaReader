//
//  Home.swift
//  MangaReader
//
//  Created by Matthew Demers on 11/28/23.
//

import Foundation
import SwiftUI

struct HomeView: View {
    let mangas: [Manga] = fetchHomePage()
    
    var body: some View {
        ScrollView {
            Text("Home")
                .font(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
            LazyVStack {
                ForEach(mangas, id: \.id) { manga in
                    MangaCardView(manga: manga)
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

func fetchHomePage() -> [Manga] {
    let url = URL(string: "https://api.mangadex.org/manga?includes[]=cover_art")!
    let request = URLRequest(url: url)
    let semaphore = DispatchSemaphore(value: 0)
    var mangas: [Manga] = []

    URLSession.shared.dataTask(with: request) { data, response, error in
        if let data = data {
            let decoder = JSONDecoder()
            let mangaResponse = try? decoder.decode(MangaResponse.self, from: data)
            mangas = mangaResponse?.data ?? []
        }
        semaphore.signal()
    }.resume()

    semaphore.wait()
    return mangas
}
