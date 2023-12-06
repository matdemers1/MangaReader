//
// Created by Matthew Demers on 12/5/23.
//

enum Status: String, CaseIterable {
  case ongoing = "ongoing"
  case completed = "completed"
  case hiatus = "hiatus"
  case cancelled = "cancelled"

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
}