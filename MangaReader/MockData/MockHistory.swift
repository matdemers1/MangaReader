//
//  MockHistory.swift
//  MangaReader
//
//  Created by Matthew Demers on 1/26/24.
//

import Foundation

let MOCK_HISTORY_ITEM: SchemaV3.History = {
  return History(
    mangaId: "1",
    mangaName: "Test Manga",
    totalChapters: 10,
    chapterIds: [],
    lastRead: Date(),
    lastReadChapterId: "1",
    coverArtURL: "Test URL"
  )
}()
