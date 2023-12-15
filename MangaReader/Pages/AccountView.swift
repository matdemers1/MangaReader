//
// Created by Matthew Demers on 12/6/23.
//

import Foundation
import SwiftUI
import SwiftData

struct AccountView: View {
  @Environment(\.modelContext) private var modelContext
  @Query private var accountSettings: [Account]

  private var showAdultContentBinding: Binding<Bool> {
    Binding<Bool>(
        get: {
          self.accountSettings.first?.miscSettings.showAdultContent ?? false
        },
        set: { newValue in
          print("Setting showAdultContent to \(newValue)")
          dump(self.accountSettings)
          print("Account settings: \(self.accountSettings.first?.miscSettings.showAdultContent)")
          self.accountSettings.first?.miscSettings.showAdultContent = newValue
        }
    )
  }

  var body: some View {
    NavigationStack {
      VStack {
        HStack {
          Text("Account")
              .font(.largeTitle.bold())
              .padding(.top)
              .padding(.horizontal)
        }
            .frame(maxWidth: .infinity, alignment: .leading)
        Toggle("Show Adult Content", isOn: showAdultContentBinding)
            .padding(.horizontal)
            .padding(.vertical, 4)
      }
          .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
          .onAppear() {
            createAccountSettings()
          }
    }
  }

  func createAccountSettings() {
    if accountSettings.isEmpty {
      let account = Account()
      try! modelContext.insert(account)
    }
  }
}



// Element for later use
//Text("All user data including favorites and reading list will be stored locally on your device. No data will be sent to any server.")
//    .font(.body)
//    .foregroundColor(.secondary)
//    .padding(.horizontal)