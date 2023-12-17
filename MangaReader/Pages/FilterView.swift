//
// Created by Matthew Demers on 12/5/23.
//

import Foundation
import SwiftUI

struct FilterView: View {
  @Binding var filterState: FilterState

  var body: some View {
    VStack(alignment: .leading) {
      Text("Filter")
          .font(.largeTitle)
          .frame(maxWidth: .infinity, alignment: .leading)

          .font(.subheadline)
          .frame(maxWidth: .infinity, alignment: .leading)
      ScrollView {
        SortFilter(filterState: $filterState)
        StatusFilter(filterState: $filterState)
        PublicationDemoFilter(filterState: $filterState)
        ContentRatingFilter(filterState: $filterState)
        TagFilter(filterState: $filterState)
      }
    }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
  }
}