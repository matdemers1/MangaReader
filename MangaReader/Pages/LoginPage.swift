//
// Created by Matthew Demers on 12/10/23.
//

import Foundation
import SwiftData
import SwiftUI

struct LoginPage: View {
  @Environment(\.modelContext) private var modelContext
  @Query private var userAuth: [UserAuth]

  @State private var username: String = ""
  @State private var password: String = ""
  @State private var clientId: String = ""
  @State private var clientSecret: String = ""
  @State private var accessToken: String = ""
  @State private var refreshToken: String = ""

  var body: some View {
    VStack {
      Text("Login")
      TextField("Username", text: $username)
      SecureField("Password", text: $password)
      TextField("Client ID", text: $clientId)
      SecureField("Client Secret", text: $clientSecret)
      Button(action: authWithMangaDex) {
        Text("Login")
      }
          .disabled(username.count < 1 || password.count < 1 || clientId.count < 1 || clientSecret.count < 1)
    }
  }

  func authWithMangaDex() {
    let url = URL(string: "https://auth.mangadex.org/realms/mangadex/protocol/openid-connect/token")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

    let bodyParameters = [
      "grant_type": "password",
      "username": username,
      "password": password,
      "client_id": clientId,
      "client_secret": clientSecret
    ]

    let bodyString = bodyParameters.map { "\($0.key)=\($0.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)" }.joined(separator: "&")
    request.httpBody = bodyString.data(using: .utf8)

    URLSession.shared.dataTask(with: request) { data, response, error in
      if let data = data {
        if let decodedResponse = try? JSONDecoder().decode(AuthResponse.self, from: data) {
          DispatchQueue.main.async {
            let userAuth = UserAuth(
                username: username,
                password: password,
                clientId: clientId,
                clientSecret: clientSecret,
                accessToken: decodedResponse.accessToken,
                refreshToken: decodedResponse.refreshToken
            )
            modelContext.insert(userAuth)
          }
          return
        }
      }
      print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
    }.resume()


  }

}