//
// Created by Matthew Demers on 12/10/23.
//

import Foundation

struct AuthResponse: Codable {
  let accessToken: String
  let refreshToken: String
}