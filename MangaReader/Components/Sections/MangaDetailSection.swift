//
// Created by Matthew Demers on 12/26/23.
//

import Foundation
import SwiftUI

struct MangaDetailSection: View {
    var manga: Manga
    var body: some View {
      VStack(spacing: 0) {
        ZStack(alignment: .bottomLeading) {
          GeometryReader { geometry in
            if let coverArtURL = manga.coverArt?.fullCoverURL {
              AsyncImage(url: URL(string: coverArtURL)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width)
              } placeholder: {
                ProgressView()
              }
            }
          }
          LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom)
              .frame(height: 480)

          // Title and Artist name
          VStack(alignment: .leading) {
            Text(manga.attributes.title["en"] ?? "Unknown Title")
                .font(.title2)
                .foregroundColor(.white)
                .padding(.top, 20)
            HStack {
              Text("Manga Id")
                .font(.body)
                .foregroundColor(.secondary)
              // Add Copy button
              Button {
                UIPasteboard.general.string = manga.id
              } label: {
                Image(systemName: "doc.on.doc")
              }
            }
          }
              .padding()

        }
        // Manga Details
        VStack(alignment: .leading, spacing: 8) {
          ExpandableText(manga.attributes.description?["en"] ?? "No description", lineLimit: 6)
              .foregroundColor(.white)
              .padding()
        }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.black)
      }
    }
}
