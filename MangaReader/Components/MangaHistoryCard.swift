//
// Created by Matthew Demers on 12/18/23.
//

import Foundation
import SwiftUI
import SwiftData

struct MangaHistoryCard: View {
  let mangaId: String
  let coverArtUrl: String?
  let mangaName: String
  let lastRead: Date?
  
  private var formattedLastRead: String {
    if let lastRead = lastRead {
      let formatter = RelativeDateTimeFormatter()
      return formatter.localizedString(for: lastRead, relativeTo: Date())
    } else {
      return "Date not available"
    }
  }
  
  var body: some View {
    NavigationLink(destination: MangaDetailView(mangaId: mangaId)) {
      ZStack {
        if let coverArtURL = coverArtUrl {
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
          Text(mangaName)
            .font(.headline)
            .foregroundColor(.white)
            .padding([.top, .leading, .trailing], 8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .lineLimit(2)
            .multilineTextAlignment(.leading)
          Spacer()
          if lastRead != nil {
            HStack {
              Text("Last read: \(formattedLastRead)")
                .font(.caption)
                .bold()
                .foregroundColor(.white)
                .padding([.leading, .bottom], 8)
              Spacer()
            }
          }
        }
      )
    }
  }
}
