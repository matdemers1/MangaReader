//
// Created by Matthew Demers on 12/5/23.
//

import Foundation

// create a enum for the order of the manga where each entry also has a asc and desc value
enum Order: String, CaseIterable {
  case title = "title"
  case year = "year"
  case createdAt = "createdAt"
  case updatedAt = "updatedAt"
  case latestUploadedChapter = "latestUploadedChapter"
  case followedCount = "followedCount"
  case relevance = "relevance"
  case rating = "rating"

  var description: String {
    switch self {
    case .title:
      return "Title"
    case .year:
      return "Year"
    case .createdAt:
      return "Created At"
    case .updatedAt:
      return "Updated At"
    case .latestUploadedChapter:
      return "Latest Uploaded Chapter"
    case .followedCount:
      return "Followed Count"
    case .relevance:
      return "Relevance"
    case .rating:
      return "Rating"
    }
  }
}

enum OrderDirection: String, CaseIterable {
  case asc = "asc"
  case desc = "desc"

  var description: String {
    switch self {
    case .asc:
      return "Ascending"
    case .desc:
      return "Descending"
    }
  }
}