//
// Created by Matthew Demers on 12/5/23.
//

import Foundation
import SwiftUI

enum Status: String, CaseIterable {
  case ongoing = "ongoing"
  case completed = "completed"
  case hiatus = "hiatus"
  case cancelled = "cancelled"

  static subscript(_ status: String?) -> Status {
    guard let status = status else {
      return .ongoing
    }
    return Status(rawValue: status) ?? .ongoing
  }

  var description: String {
    switch self {
    case .ongoing:
      return "Ongoing"
    case .completed:
      return "Completed"
    case .hiatus:
      return "Hiatus"
    case .cancelled:
      return "Cancelled"
    }
  }

  var color: Color {
    switch self {
    case .ongoing:
      return .blue
    case .completed:
      return .teal
    case .hiatus:
      return .purple
    case .cancelled:
      return .red
    }
  }
}