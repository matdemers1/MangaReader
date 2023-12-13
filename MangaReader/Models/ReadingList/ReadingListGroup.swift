//
// Created by Matthew Demers on 12/13/23.
//

import Foundation
import SwiftData

@Model
class ReadingListGroup {
  var groupId: UUID
  var groupName: String
  // Relationships not works so like i guess we'll just do this
  var readingListItems:[ReadingListItem] = []

  init(groupId: UUID, groupName: String) {
    self.groupId = groupId
    self.groupName = groupName
  }
}

