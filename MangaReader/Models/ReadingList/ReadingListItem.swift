//
// Created by Matthew Demers on 12/13/23.
//

import Foundation
import SwiftData

@Model
class ReadingListItem {
  var mangaId: String
  var mangaName: String

  init(mangaId: String, mangaName: String) {
    self.mangaId = mangaId
    self.mangaName = mangaName
  }
}
