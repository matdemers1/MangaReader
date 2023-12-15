//
//  Search.swift
//  MangaReader
//
//  Created by Matthew Demers on 11/28/23.
//

import Foundation
import SwiftUI

struct SearchView: View {
    @State var showSheet = false
    @State var filterState = FilterState()
    @State var mangaList: [Manga] = []
    @State var page = 0
    @State var totalPages = 0

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Search")
                        .font(.largeTitle.bold())
                        .padding()
                    Spacer()
                }
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search", text: $filterState.title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onSubmit({
                            page = 0
                            search()
                        })
                    Spacer()
                    Button(action: {
                        showSheet.toggle()
                    }) {
                        Image(systemName: "slider.horizontal.3")
                    }
                        .sheet(isPresented: $showSheet, content: {
                            FilterView(filterState: $filterState)
                        })
                }
                    .padding(.horizontal, 8)
                if !mangaList.isEmpty {
                    ScrollView {
                        LazyVStack {
                            ForEach(mangaList, id: \.id) { manga in
                                NavigationLink(destination: MangaDetailView(manga: manga, mangaId: manga.id.description)) {
                                    MangaCardView(manga: manga)
                                }
                            }
                        }
                            .padding(.horizontal, 8)
                        HStack {
                            Spacer()
                            Button(action: {
                                if page > 0 {
                                    page -= 1
                                    search()
                                }
                            }) {
                                Image(systemName: "chevron.left")
                            }
                                .disabled(page == 0)
                            Text("\(page + 1) / \(totalPages)")
                            Button(action: {
                                if page < totalPages - 1 {
                                    page += 1
                                    search()
                                }
                            }) {
                                Image(systemName: "chevron.right")
                            }
                                .disabled(page == totalPages - 1)
                            Spacer()
                        }
                            .padding(.vertical, 8)
                            .padding(.bottom, 16)
                    }
                } else {
                    Text("No results")
                }
            }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
            .navigationTitle("Search")
            .overlay{
                if mangaList.isEmpty {
                    ContentUnavailableView(
                        "No results",
                        systemImage: "magnifyingglass",
                        description: Text("Try changing your search terms or filters")
                    )
                }
            }
    }

    func search() {
        var request = URLRequest(url: urlBuilder())
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            if let decodedResponse = try? JSONDecoder().decode(MangaResponse.self, from: data) {
                DispatchQueue.main.async {
                    self.mangaList = decodedResponse.data
                    var totalMangas = decodedResponse.total ?? 0
                    // get the totalPages by dividing the total mangas by the limit
                    self.totalPages = totalMangas / (decodedResponse.limit ?? 0)
                    // if there is a remainder, add 1 to the totalPages
                    if totalMangas % (decodedResponse.limit ?? 0) != 0 {
                        self.totalPages += 1
                    }
                }
                return
            }
            print("Invalid response from server")
        }.resume()
    }

    func urlBuilder() -> URL {
        var url = URLComponents(string: "https://api.mangadex.org/manga")!
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "limit", value: "20"))
        queryItems.append(URLQueryItem(name: "offset", value: String(page * 20)))
        queryItems.append(URLQueryItem(name: "includes[]", value: "cover_art"))
        if !filterState.title.isEmpty {
            queryItems.append(URLQueryItem(name: "title", value: filterState.title))
        }
        if let order = filterState.order {
            queryItems.append(URLQueryItem(name: "order", value: order.rawValue))
        }
        if let orderDirection = filterState.orderDirection {
            queryItems.append(URLQueryItem(name: "orderDirection", value: orderDirection.rawValue))
        }
        if let year = filterState.year {
            queryItems.append(URLQueryItem(name: "year", value: String(year)))
        }
        if let includedTags = filterState.includedTags, !includedTags.isEmpty {
            queryItems.append(URLQueryItem(name: "includedTags[]", value: includedTags.map { $0.id }.joined(separator: ",")))
        }
        if let excludeTags = filterState.excludeTags, !excludeTags.isEmpty {
            queryItems.append(URLQueryItem(name: "excludedTags[]", value: excludeTags.map { $0.id }.joined(separator: ",")))
        }
        if let status = filterState.status, !status.isEmpty {
            queryItems.append(URLQueryItem(name: "status[]", value: status.map { $0.rawValue }.joined(separator: ",")))
        }
        if let publicationDemographic = filterState.publicationDemographic, !publicationDemographic.isEmpty {
            queryItems.append(URLQueryItem(name: "publicationDemographic[]", value: publicationDemographic.map { $0.rawValue }.joined(separator: ",")))
        }
        if let contentRating = filterState.contentRating, !contentRating.isEmpty {
            queryItems.append(URLQueryItem(name: "contentRating[]", value: contentRating.map { $0.rawValue }.joined(separator: ",")))
        }
        url.queryItems = queryItems
        return url.url!
    }
}
