//
// Created by Matthew Demers on 12/5/23.
//

import Foundation
import SwiftUI

struct StatusFilter: View {
  @Binding var filterState: FilterState
  @State private var isExpanded: Bool = false

  var columns: [GridItem] = [
    GridItem(.flexible(), spacing: 8),
    GridItem(.flexible())
  ]

  var body: some View {
    VStack {
      HStack {
        Text("Status")
            .font(.headline)

        Spacer()
        if !isExpanded && filterState.status?.count ?? 0 > 0 {
          Text("\(filterState.status?.count ?? 0) selected")
              .font(.subheadline)
              .foregroundColor(.secondary)
        }

        Image(systemName: "chevron.down")
            .rotationEffect(.degrees(isExpanded ? 180 : 0)) // Rotate the icon based on isExpanded
            .animation(.easeInOut, value: isExpanded) // Animate the rotation
      }
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding()
          .cornerRadius(16)
          .onTapGesture {
            withAnimation { // Animate the expansion and collapse
              isExpanded.toggle()
            }
          }

      if isExpanded {
        LazyVGrid(columns: columns, spacing: 16) { // Adjust spacing here
          ForEach(Status.allCases, id: \.self) { status in
            Button(action: {
              if filterState.status?.contains(status) ?? false {
                filterState.status?.removeAll(where: { $0 == status })
              } else {
                filterState.status?.append(status)
              }
            }) {
              Text(status.description)
                  .padding(.vertical, 8)
                  .padding(.horizontal, 4) // Add horizontal padding to buttons
                  .font(.subheadline)
                  .frame(maxWidth: .infinity)
                  .foregroundColor(filterState.status?.contains(status) ?? false ? .blue : .primary)
                  .background(filterState.status?.contains(status) ?? false ? Color.blue.opacity(0.05) : Color.clear)
                  .cornerRadius(16)
                  .overlay(
                      RoundedRectangle(cornerRadius: 16)
                          .stroke(
                              filterState.status?.contains(status) ?? false ? .blue : .primary,
                              lineWidth: 1)
                  )
            }
          }
        }
            .padding(.bottom)
      }
    }
        .padding(.horizontal, 16)
        .background(Color("FilterCardBackground"))
        .cornerRadius(16)
        .animation(.easeInOut, value: isExpanded) // Apply animation to the expansion/collapse
  }
}

