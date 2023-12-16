//
// Created by Matthew Demers on 12/15/23.
//

import Foundation
import SwiftData

enum SchemaV1: VersionedSchema{
  static var versionIdentifier = Schema.Version(1,0,0)
  private(set) static var models: [any PersistentModel.Type] = [
    Account.self,
    History.self,
    ReadingListGroup.self,
    ReadingListItem.self,
  ]
}

extension SchemaV1 {
  @Model
  class Account {
    var miscSettings: MiscSettings

    init() {
      self.miscSettings = MiscSettings()
    }
  }

  @Model
  class MiscSettings {
    var showAdultContent: Bool

    init() {
      self.showAdultContent = false
    }
  }

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

  @Model
  class ReadingListItem {
    var mangaId: String
    var mangaName: String

    init(mangaId: String, mangaName: String) {
      self.mangaId = mangaId
      self.mangaName = mangaName
    }
  }
}