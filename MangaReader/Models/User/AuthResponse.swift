//
// Created by Matthew Demers on 12/10/23.
//

import Foundation

struct AuthResponse: Codable {
  let accessToken: String
  let expiresIn: Int
  let refreshExpiresIn: Int
  let refreshToken: String
  let tokenType: String
  let notBeforePolicy: Int
  let sessionState: String
  let scope: String
  let clientType: String

  enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
    case expiresIn = "expires_in"
    case refreshExpiresIn = "refresh_expires_in"
    case refreshToken = "refresh_token"
    case tokenType = "token_type"
    case notBeforePolicy = "not-before-policy"
    case sessionState = "session_state"
    case scope
    case clientType = "client_type"
  }
}
