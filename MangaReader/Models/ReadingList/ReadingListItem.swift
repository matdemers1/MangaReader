//
// Created by Matthew Demers on 12/13/23.
//

import Foundation
import SwiftData

@Model
class ReadingListItem {
  var mangaId: String
  var mangaName: String
  var lastRead: Date

  init(mangaId: String, mangaName: String, lastRead: Date) {
    self.mangaId = mangaId
    self.mangaName = mangaName
    self.lastRead = lastRead
  }
}
