//
// Created by Matthew Demers on 12/5/23.
//

import Foundation
import SwiftUI

enum ContentRating: String, CaseIterable{
  case safe = "safe"
  case suggestive = "suggestive"
  case erotica = "erotica"
  case pornographic = "pornographic"

  var description: String {
    switch self {
    case .safe:
      return "Safe"
    case .suggestive:
      return "Suggestive"
    case .erotica:
      return "Erotica"
    case .pornographic:
      return "Pornographic"
    }
  }

  var color: Color{
    switch self {
    case .safe:
      return .green
    case .suggestive:
      return .yellow
    case .erotica:
      return .orange
    case .pornographic:
      return .red
    }
  }
}
