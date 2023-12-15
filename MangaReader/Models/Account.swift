//
// Created by Matthew Demers on 12/7/23.
//

import Foundation
import SwiftData

@Model
class Account {
  var miscSettings: MiscSettings

  init() {
    self.miscSettings = MiscSettings()
  }
}

@Model
class MiscSettings {
  var showAdultContent: Bool

  init() {
    self.showAdultContent = false
  }
}
