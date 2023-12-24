//
// Created by Matthew Demers on 12/5/23.
//

import Foundation
import SwiftUI

struct TagFilterSection: View{
  @Binding var filterState: FilterState
  var tags: [Tag]
  var header: String

  var columns: [GridItem] = [
    GridItem(.flexible(), spacing: 8),
    GridItem(.flexible())
  ]

  var body: some View {
    VStack {
      Text(header)
          .font(.caption)
          .foregroundColor(.secondary)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.horizontal, 8)
          .padding(.top, 16)

      Divider()
          .padding(.bottom, 4)
          .frame(height: 4)

      LazyVGrid(columns: columns, spacing: 16) { // Adjust spacing here
        ForEach(tags, id: \.id) { tag in
          Button(action: {
            if filterState.includedTags?.contains(tag) ?? false {
              filterState.includedTags?.removeAll(where: { $0 == tag })
              filterState.excludeTags?.append(tag)
            } else if filterState.excludeTags?.contains(tag) ?? false {
              filterState.excludeTags?.removeAll(where: { $0 == tag })
            } else {
              filterState.includedTags?.append(tag)
            }
          }) {
            Text(tag.attributes.name["en"] ?? "")
                .padding(.vertical, 8)
                .padding(.horizontal, 4) // Add horizontal padding to buttons
                .font(.subheadline)
                .frame(maxWidth: .infinity)
          }
              .foregroundColor(getTextColor(tag: tag))
              .background(
                  RoundedRectangle(cornerRadius: 4)
                      .fill(
                        isInIncludedOrExcluded(tag: tag) ? getTextColor(tag: tag).opacity(0.05) : Color.clear)
              )
              .overlay(
                  RoundedRectangle(cornerRadius: 4)
                      .stroke(
                          getTextColor(tag: tag),
                          lineWidth: 1)
              )
        }
      }
          .padding(.horizontal, 8)
    }
  }

  func isInIncludedOrExcluded(tag: Tag) -> Bool {
    return filterState.includedTags?.contains(tag) ?? false
        || filterState.excludeTags?.contains(tag) ?? false
  }

  func getTextColor(tag: Tag) -> Color {
    if filterState.includedTags?.contains(tag) ?? false {
      return .blue
    } else if filterState.excludeTags?.contains(tag) ?? false {
      return .red
    } else {
      return .primary
    }
  }
}
