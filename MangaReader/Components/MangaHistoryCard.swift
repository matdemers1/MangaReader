//
// Created by Matthew Demers on 12/18/23.
//

import Foundation
import SwiftUI
import SwiftData

struct MangaHistoryCard: View {
  let historyItem: History

  var body: some View {
    ZStack{
      if let coverArtURL = historyItem.coverArtURL {
        AsyncImage(url: URL(string: coverArtURL)) { image in
          image
              .resizable()
              .aspectRatio(contentMode: .fill)
              .blur(radius: 10)
        } placeholder: {
          Color.gray
        }
      } else {
        Color.gray
      }
    }
        // set the width of the card to be 80% of the screen
        .frame(width: UIScreen.main.bounds.width * 0.9, height: 100)
        .cornerRadius(10)
        .overlay(
            VStack(alignment: .leading) {
              Text(historyItem.mangaName)
                  .font(.headline)
                  .foregroundColor(.white)
                  .padding([.top, .leading, .trailing], 8)
              Spacer()
              HStack {
                Text("Last Read: \(historyItem.lastRead)")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding([.leading, .bottom], 8)
                Spacer()
              }
            }
        )
  }
}