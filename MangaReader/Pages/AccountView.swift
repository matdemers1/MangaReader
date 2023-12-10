//
// Created by Matthew Demers on 12/6/23.
//

import Foundation
import SwiftUI

struct AccountView: View {
  var body: some View {
    NavigationStack {
      VStack {
        AccountHeader()
        Spacer()
      }
          .navigationTitle("Account")
    }
  }
}