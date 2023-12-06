//
// Created by Matthew Demers on 12/5/23.
//

import Foundation

enum PublicationDemographic: String, CaseIterable {
  case shounen = "shounen"
  case shoujo = "shoujo"
  case josei = "josei"
  case seinen = "seinen"

  var description: String {
    switch self {
    case .shounen:
      return "Shounen"
    case .shoujo:
      return "Shoujo"
    case .josei:
      return "Josei"
    case .seinen:
      return "Seinen"
    }
  }
}