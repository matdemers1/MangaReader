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
                  .frame(width: 68.75, height: 100)
                  .cornerRadius(10)
                  .padding(8)
            } placeholder: {
              SkeletonBox(height: 100, width: 68.75)
                  .padding(8)
            }
          }

          // Manga Info
          VStack(alignment: .leading) {
            Text(manga.attributes.title["en"] ?? "Unknown Title")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .foregroundColor(.primary)
                .padding([.bottom], 8)
            Text(manga.attributes.description?["en"] ?? "No description")
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .lineLimit(4)
          }.padding([.top], 8)
        }
        WrappingHStack(alignment: .leading, fitContentWidth: true) {
          Text("Status: \(manga.attributes.status?.capitalized ?? "N/A")")
              .withPillStyle()
          Text("Year: \(manga.attributes.year.map(String.init) ?? "N/A")")
              .withPillStyle()
          Text("Rating: \(manga.attributes.contentRating?.capitalized ?? "N/A")")
              .withPillStyle()
          Text("State: \(manga.attributes.state?.capitalized ?? "N/A")")
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
        .padding([.bottom], 8)
  }
}



