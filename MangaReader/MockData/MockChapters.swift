//
//  MockChapters.swift
//  MangaReader
//
//  Created by Matthew Demers on 1/26/24.
//

import Foundation

let MOCK_CHAPTERS: [Chapter] = generateMockChapter(count: 10)

func generateMockChapter(count: Int) -> [Chapter] {
  var chapters: [Chapter] = []
  for index in 0..<count {
    let randomPages = Int.random(in: 20..<100)
    chapters.append(
      Chapter(
        id: UUID(),
        type: "chapter",
        attributes: ChapterAttributes(
          title: "Chapter \(index.description)",
          volume: index.description,
          chapter: index.description,
          pages: randomPages,
          translatedLanguage: "en",
          uploader: UUID(),
          externalUrl: nil,
          version: 1,
          createdAt: "2021-04-19T21:45:59+00:00",
          updatedAt: "2021-04-19T21:45:59+00:00",
          publishAt: "2021-04-19T21:45:59+00:00",
          readableAt: "2021-04-19T21:45:59+00:00"
        ),
        relationships: []
      )
    )
  }
  return chapters
}
