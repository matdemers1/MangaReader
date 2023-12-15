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
  let showTags: Bool

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
          Text(manga.attributes.contentRating?.capitalized ?? "N/A")
              .withPillStyle(color: ContentRating( rawValue: manga.attributes.contentRating ?? "safe" )?.color ?? .primary)
          Text("Status: \(manga.attributes.status?.capitalized ?? "N/A")")
              .withPillStyle(color: Status( rawValue: manga.attributes.status ?? "ongoing" )?.color ?? .primary)
          Text("Year: \(manga.attributes.year.map(String.init) ?? "N/A")")
              .withPillStyle(color: .primary)
          if showTags {
            ForEach(manga.attributes.tags ?? [], id: \.self) { tag in
              Text(tag.attributes.name["en"] ?? "Unknown Tag")
                  .withPillStyle(color: .primary)
            }
          }
        }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
      }
          .frame(maxWidth: .infinity, alignment: .leading)
          .background(Color("CardBackground"))
          .cornerRadius(10)
          .shadow(radius: 5)
    }
        .padding([.bottom], 8)
  }
}



