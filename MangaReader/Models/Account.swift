//
// Created by Matthew Demers on 12/7/23.
//

import Foundation
import SwiftData

@Model
class Account {
  var history: [History] = []

  init(history: [History]) {
    self.history = history
  }
}
