//
// Created by Matthew Demers on 12/17/23.
//

import Foundation
import SwiftUI

struct SortFilter: View {
    @Binding var filterState: FilterState

    var body: some View {
        VStack {
          HStack {
            Text("Sort By: ")
                .font(.body)
                .padding(.horizontal)
            Spacer()
            Picker("Sort By:", selection: $filterState.order) {
              ForEach(Order.allCases, id: \.self) { order in
                Text(order.description).tag(order)
              }
            }
                .padding(.horizontal)
                .padding(.vertical, 4)
          }
          HStack {
            Text("Order By: ")
                .font(.body)
                .padding(.horizontal)
            Spacer()
            Picker("Order By:", selection: $filterState.orderDirection) {
              ForEach(OrderDirection.allCases, id: \.self) { direction in
                Text(direction.description).tag(direction)
              }
            }
                .padding(.horizontal)
                .padding(.vertical, 4)
          }
        }
    }
}