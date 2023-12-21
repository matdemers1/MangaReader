//
// Created by Matthew Demers on 12/18/23.
//

import Foundation
import SwiftUI

struct ChapterMenu: View{
  @Binding var viewType: ViewType

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
    } label: {
        Image(systemName: "ellipsis.circle")
          .font(.system(size: 16))
    }
  }
}