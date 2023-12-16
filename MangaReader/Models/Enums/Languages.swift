//
// Created by Matthew Demers on 12/15/23.
//

import Foundation

enum Languages: String, CaseIterable {
  case all = "all"
  case english = "en"
  case japanese = "ja"
  case spanish = "es"
  case german = "de"


  static subscript(_ language: String?) -> Languages {
    guard let language = language else {
      return .english
    }
    return Languages(rawValue: language) ?? .english
  }

  var description: String {
    switch self {
    case .all:
      return "All"
    case .english:
      return "English"
    case .japanese:
      return "Japanese"
    case .spanish:
      return "Spanish"
    case .german:
      return "German"
    }
  }

  var flagEmoji: String {
    switch self {
    case .all:
      return "🌐"
    case .english:
      return "🇺🇸"
    case .japanese:
      return "🇯🇵"
    case .spanish:
      return "🇪🇸"
    case .german:
      return "🇩🇪"
    }
  }
}