//
// Created by Matthew Demers on 12/5/23.
//

import Foundation
import SwiftUI
import SwiftData

struct ContentRatingFilter: View{
  @Query private var accountSettings: [Account]
  @Binding var filterState: FilterState
  @State private var isExpanded: Bool = false

  private var contentRating: [ContentRating] {
    if let account = accountSettings.first {
      if account.showAdultContent {
        return ContentRating.allCases
      } else {
        return ContentRating.allCases.filter { $0 != .pornographic }
      }
    } else {
      return []
    }
  }

  var columns: [GridItem] = [
    GridItem(.flexible(), spacing: 8),
    GridItem(.flexible())
  ]

  var body: some View {
    VStack {
      HStack {
        Text("Content Rating")
        Spacer()
        if !isExpanded && filterState.contentRating?.count ?? 0 > 0 {
          Text("\(filterState.contentRating?.count ?? 0) selected")
              .font(.subheadline)
              .foregroundColor(.secondary)
        }

        Image(systemName: "chevron.down")
            .rotationEffect(.degrees(isExpanded ? 180 : 0)) // Rotate the icon based on isExpanded
            .animation(.easeInOut, value: isExpanded) // Animate the rotation
      }
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.vertical, 8)
          .padding(.trailing, 16)
          .onTapGesture {
            withAnimation { // Animate the expansion and collapse
              isExpanded.toggle()
            }
          }

      if isExpanded {
        LazyVGrid(columns: columns, spacing: 16) { // Adjust spacing here
          ForEach(contentRating, id: \.self) { contentRating in
            Button(action: {
              if filterState.contentRating?.contains(contentRating) ?? false {
                filterState.contentRating?.removeAll(where: { $0 == contentRating })
              } else {
                filterState.contentRating?.append(contentRating)
              }
            }) {
              Text(contentRating.description)
                  .padding(.vertical, 8)
                  .padding(.horizontal, 4) // Add horizontal padding to buttons
                  .font(.subheadline)
                  .frame(maxWidth: .infinity)
                  .foregroundColor(filterState.contentRating?.contains(contentRating) ?? false ? .blue : .primary)
                  .background(filterState.contentRating?.contains(contentRating) ?? false ? Color.blue.opacity(0.05) : Color.clear)
                  .overlay(
                      RoundedRectangle(cornerRadius: 4)
                          .stroke(
                              filterState.contentRating?.contains(contentRating) ?? false ? .blue : .primary,
                              lineWidth: 1)
                  )
            }
          }
        }
            .padding(.bottom)
      }
    }
        .padding(.horizontal, 16)
        .animation(.easeInOut, value: isExpanded) // Apply animation to the expansion/collapse
  }
}