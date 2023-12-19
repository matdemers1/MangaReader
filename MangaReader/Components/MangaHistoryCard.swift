//
// Created by Matthew Demers on 12/18/23.
//

import Foundation
import SwiftUI
import SwiftData

struct MangaHistoryCard: View {
  let historyItem: History

  var body: some View {
    NavigationLink(destination: MangaDetailView(mangaId: historyItem.mangaId)) {
      ZStack {
        if let coverArtURL = historyItem.coverArtURL {
          AsyncImage(url: URL(string: coverArtURL)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .blur(radius: 4)
                .brightness(-0.5)
          } placeholder: {
            Color.gray
          }
        } else {
          Color.gray
        }
      }
          // set the width of the card to be 80% of the screen
          .frame(width: 150, height: 200)
          .cornerRadius(10)
          .overlay(
              VStack(alignment: .leading) {
                Text(historyItem.mangaName)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding([.top, .leading, .trailing], 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                Spacer()
                HStack {
                  Text("Last read: \(historyItem.lastRead, formatter: RelativeDateTimeFormatter())")
                      .font(.caption)
                      .bold()
                      .foregroundColor(.white)
                      .padding([.leading, .bottom], 8)
                  Spacer()
                }
              }
          )
    }
  }
}