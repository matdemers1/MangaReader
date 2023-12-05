//
// Created by Matthew Demers on 12/5/23.
//

import Foundation
import SwiftUI

struct FilterView:View {
  var body: some View {
    VStack {
      Text("Filter")
        .font(.largeTitle)
        .frame(maxWidth: .infinity, alignment: .leading)
      HStack {
       Text("Filters Go Here")
      }
    }
  }
}