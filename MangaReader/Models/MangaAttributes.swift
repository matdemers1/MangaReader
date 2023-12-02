//
//  MangaAttributes.swift
//  MangaReader
//
//  Created by Matthew Demers on 11/28/23.
//

import Foundation

struct MangaAttributes: Codable {
    let title: Title
    let altTitles: [Title]?
    let description: Description?
    let isLocked: Bool?
    let links: [String: String]?
    let originalLanguage: String?
    let lastVolume: String?
    let lastChapter: String?
    let publicationDemographic: String?
    let status: String?
    let year: Int?
    let contentRating: String?
    let tags: [Tag]?
    let state: String?
    let chapterNumbersResetOnNewVolume: Bool?
    let createdAt: String?
    let updatedAt: String?
    let version: Int?
    let availableTranslatedLanguages: [String]?
    let latestUploadedChapter: String?
}
