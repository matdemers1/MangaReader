//
// Created by Matthew Demers on 12/9/23.
//

import Foundation
import SwiftData

@Model
class UserAuth{
  var username: String
  var password: String
  var clientId: String
  var clientSecret: String
  var accessToken: String
  var refreshToken: String

  init(username: String, password: String, clientId: String, clientSecret: String, accessToken: String, refreshToken: String) {
    self.username = username
    self.password = password
    self.clientId = clientId
    self.clientSecret = clientSecret
    self.accessToken = accessToken
    self.refreshToken = refreshToken
  }
}