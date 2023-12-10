//
// Created by Matthew Demers on 12/6/23.
//

import Foundation
import SwiftUI
import SwiftData

struct AccountHeader: View {
  @Environment(\.modelContext) private var modelContext
  @Query private var userAuth: [UserAuth]

  @State private var showLoginSheet = false

  var body: some View {
    VStack {
      HStack {
        Text("This is place holder while I figure out how to get the user's name")
        Spacer()
        if !userAuth.isEmpty {
          Button(action: logout) {
            Text("Logout")
          }
        } else {
          Button("Login") {
            showLoginSheet = true
          }
              .sheet(isPresented: $showLoginSheet) {
                LoginPage()
          }
        }
      }
    }
  }

  func logout() {
    for auth in userAuth {
      modelContext.delete(auth)
    }
  }
}
