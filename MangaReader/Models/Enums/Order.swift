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
  case revelance = "revelance"
  case rating = "rating"
}

enum OrderDirection: String, CaseIterable {
  case asc = "asc"
  case desc = "desc"
}