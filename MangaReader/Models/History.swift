//
// Created by Matthew Demers on 12/7/23.
//

import Foundation
import SwiftData

@Model
class History {
  @Attribute(.unique) var mangaId: String
  var mangaName: String
  var totalChapters: Int
  var chapterIds: [String]
  var lastRead: Date
  var lastReadChapterId: String

  init(mangaId: String, mangaName: String, totalChapters: Int, chapterIds: [String], lastRead: Date, lastReadChapterId: String) {
    self.mangaId = mangaId
    self.mangaName = mangaName
    self.totalChapters = totalChapters
    self.chapterIds = chapterIds
    self.lastRead = lastRead
    self.lastReadChapterId = lastReadChapterId
  }
}
