//
// Created by Matthew Demers on 12/6/23.
//

import Foundation
import SwiftUI

struct AccountHeader: View {
  var body: some View {
    VStack {
      HStack {
        Text("Account")
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding(.leading, 20)
        Spacer()
      }
    }
  }
}
