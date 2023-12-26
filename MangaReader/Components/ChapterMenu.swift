//
// Created by Matthew Demers on 12/18/23.
//

import Foundation
import SwiftUI

struct ChapterMenu: View{
  @Binding var viewType: ViewType
  @Binding var dataType: DataTypes
  var clearAndRefetchData: () -> Void

  var body: some View {
    Menu {
      Button(action: {
        viewType = .longStrip
      }) {
        Label("Long Strip", systemImage: "rectangle.grid.1x2")
      }

      Button(action: {
        viewType = .singlePage
      }) {
        Label("Single Page", systemImage: "square.grid.2x2")
      }

      Button(action: {
        dataType = .data
        clearAndRefetchData()
      }) {
        Label("Full Quality", systemImage: "photo")
      }

      Button(action: {
        dataType = .dataSaver
        clearAndRefetchData()
      }) {
        Label("Data Saver", systemImage: "photo")
      }
    } label: {
        Image(systemName: "ellipsis.circle")
          .font(.system(size: 16))
    }
  }
}