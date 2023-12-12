//
//  MangaCardView.swift
//  MangaReader
//
//  Created by Matthew Demers on 11/28/23.
//

import Foundation
import SwiftUI
import WrappingHStack

struct MangaCardView: View {
    let manga: Manga

    var body: some View {
        NavigationLink(destination: MangaDetailView(manga: manga, mangaId: manga.id.description)) {
            VStack {
                HStack(alignment: .top) {
                    // Cover Art
                    if let coverArtURL = manga.coverArt?.thumbnailURL256 {
                        AsyncImage(url: URL(string: coverArtURL)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 100)
                                .cornerRadius(10)
                                .padding(8)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                    
                    // Manga Info
                    VStack(alignment: .leading) {
                        Text(manga.attributes.title["en"] ?? "Unknown Title")
                            .font(.headline)
                        Text(manga.attributes.description?["en"] ?? "No description")
                            .font(.caption)
                            .lineLimit(4)
                    }.padding([.top], 8)
                }
                WrappingHStack(alignment: .center) {
                    Text("Last Chapter: \(manga.attributes.lastChapter ?? "N/A")")
                        .withPillStyle()
                    Text("Status: \(manga.attributes.status ?? "N/A")")
                        .withPillStyle()
                    Text("Year: \(manga.attributes.year.map(String.init) ?? "N/A")")
                        .withPillStyle()
                    Text("Content Rating: \(manga.attributes.contentRating ?? "N/A")")
                        .withPillStyle()
                    Text("State: \(manga.attributes.state ?? "N/A")")
                        .withPillStyle()
                }
                .font(.footnote)
                // Tags
                WrappingHStack(alignment: .center) {
                    ForEach(manga.attributes.tags ?? [], id: \.id) { tag in
                        Text(tag.attributes.name["en"] ?? "Unknown")
                            .withPillStyle()
                    }
                }
                .padding()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color("CardBackground"))
            .cornerRadius(10)
            .shadow(radius: 5)
        }
    }
}



