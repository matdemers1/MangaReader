//
//  Search.swift
//  MangaReader
//
//  Created by Matthew Demers on 11/28/23.
//

import Foundation
import SwiftUI
import SwiftData

struct SearchView: View {
    @Query private var accountSettings: [Account]
    @State var showSheet = false
    @State var filterState = FilterState()
    @State var mangaList: [Manga] = []
    @State var page = 0
    @State var totalPages = 0
    @State var isFetching = false
    @State var hasError = false

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
                        Image(systemName: "slider.horizontal.2.square")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                        .sheet(isPresented: $showSheet, content: {
                            FilterView(filterState: $filterState)
                        })
                }
                    .padding(.horizontal, 8)
                Button(action: {
                    page = 0
                    search()
                }) {
                    Text("Search")
                        .frame(maxWidth: .infinity)
                }
                    .buttonStyle(.borderedProminent)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                if !mangaList.isEmpty && !isFetching && !hasError {
                    ScrollView {
                        LazyVStack {
                            ForEach(mangaList, id: \.id) { manga in
                                NavigationLink(destination: MangaDetailView(manga: manga, mangaId: manga.id.description)) {
                                    MangaCardView(manga: manga, showTags: true)
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
                }
            }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
            .navigationTitle("Search")
            .overlay{
                if isFetching {
                    ProgressView()
                } else if hasError {
                    ContentUnavailableView(
                        "Error",
                        systemImage: "exclamationmark.triangle",
                        description: Text("An error occurred while fetching data")
                    )
                } else if mangaList.isEmpty {
                    ContentUnavailableView(
                        "No results",
                        systemImage: "magnifyingglass",
                        description: Text("Try changing your search terms or filters")
                    )
                }
            }
    }

    func search() {
        self.isFetching = true // Set isFetching to true at the start of the function
        self.hasError = false // Reset hasError to false at the start

        var request = URLRequest(url: urlBuilder())
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { [self] data, response, error in
                defer {
                    DispatchQueue.main.async {
                        self.isFetching = false // Set isFetching to false when the task is completed or fails
                    }
                }

                guard let data = data else {
                    DispatchQueue.main.async {
                        self.hasError = true // Set hasError to true in case of no data
                        print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                    }
                    return
                }
                do {
                    let decodedResponse = try JSONDecoder().decode(MangaResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.mangaList = decodedResponse.data
                        var totalMangas = decodedResponse.total ?? 0
                        self.totalPages = totalMangas / (decodedResponse.limit ?? 0)
                        if totalMangas % (decodedResponse.limit ?? 0) != 0 {
                            self.totalPages += 1
                        }
                        self.hasError = false // Set hasError to false on successful decoding
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.hasError = true // Set hasError to true in case of a decoding error
                        print("Decoding error: \(error.localizedDescription)")
                    }
                }
            }.resume()
    }

    func urlBuilder() -> URL {
        let language = accountSettings.first?.isTranslatedTo ?? Languages.english.rawValue

        var url = URLComponents(string: "https://api.mangadex.org/manga")!
        var queryItems: [URLQueryItem] = []
        if language != Languages.all.description {
            queryItems.append(URLQueryItem(name: "availableTranslatedLanguage[]", value: language))
        }

        queryItems.append(URLQueryItem(name: "limit", value: "20"))
        queryItems.append(URLQueryItem(name: "offset", value: String(page * 20)))
        queryItems.append(URLQueryItem(name: "includes[]", value: "cover_art"))
        queryItems.append(URLQueryItem(name: "order[\(filterState.order.rawValue)]", value: filterState.orderDirection.rawValue))
        if !filterState.title.isEmpty {
            queryItems.append(URLQueryItem(name: "title", value: filterState.title))
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
        print(url.url!)
        return url.url!
    }
}
