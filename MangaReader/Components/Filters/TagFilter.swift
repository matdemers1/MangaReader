//
// Created by Matthew Demers on 12/5/23.
//

import Foundation
import SwiftUI

struct TagFilter: View {
  @Binding var filterState: FilterState
  @State private var isExpanded: Bool = false
  @State private var tags: [Tag] = []

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Text("Tags")

        Spacer()
        if filterState.includedTags?.count ?? 0 > 0 {
          Text("\(filterState.includedTags?.count ?? 0) Included / \(filterState.excludeTags?.count ?? 0) Excluded")
              .font(.subheadline)
              .foregroundColor(.secondary)
        }

        Image(systemName: "chevron.down")
            .rotationEffect(.degrees(isExpanded ? 180 : 0)) // Rotate the icon based on isExpanded
            .animation(.easeInOut, value: isExpanded) // Animate the rotation
      }
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.vertical, 8)
          .padding(.trailing, 16)          .cornerRadius(16)
          .onTapGesture {
            withAnimation { // Animate the expansion and collapse
              isExpanded.toggle()
            }
          }

      if isExpanded {
        TagFilterSection(
            filterState: $filterState,
            tags: tags.filter { $0.attributes.group == "content" },
            header: "Content"
        )
        TagFilterSection(
            filterState: $filterState,
            tags: tags.filter { $0.attributes.group == "theme" },
            header: "Theme"
        )
        TagFilterSection(
            filterState: $filterState,
            tags: tags.filter { $0.attributes.group == "format" },
            header: "Format"
        )
        TagFilterSection(
            filterState: $filterState,
            tags: tags.filter { $0.attributes.group == "genre" },
            header: "Genre"
        )
      }
    }
        .padding(.horizontal, 16)
        .padding(.bottom, isExpanded ? 32 : 0)
        .animation(.easeInOut, value: isExpanded)
        .onAppear(perform: fetchTagsAndCache)
  }

  func fetchTagsAndCache() {
    let url = URL(string: "https://api.mangadex.org/manga/tag")!
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("application/json", forHTTPHeaderField: "Accept")

    URLSession.shared.dataTask(with: request) { data, response, error in
          if let data = data {
            if let decodedResponse = try? JSONDecoder().decode(TagResponse.self, from: data) {
              DispatchQueue.main.async {
                // update our UI
                self.tags = decodedResponse.data
                return
              }
            }
          }

          // if we're still here it means there was a problem
          print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
  }
}

