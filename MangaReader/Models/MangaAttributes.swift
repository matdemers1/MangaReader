//
//  MangaAttributes.swift
//  MangaReader
//
//  Created by Matthew Demers on 11/28/23.
//

import Foundation

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

    enum CodingKeys: String, CodingKey {
        case title
        case altTitles
        case description
        case isLocked
        case links
        case originalLanguage
        case lastVolume
        case lastChapter
        case publicationDemographic
        case status
        case year
        case contentRating
        case tags
        case state
        case chapterNumbersResetOnNewVolume
        case createdAt
        case updatedAt
        case version
        case availableTranslatedLanguages
        case latestUploadedChapter
    }
  
    init(
      title: Title, altTitles: [Title]?, description: Description?,
      isLocked: Bool?, links: [String: String]?,
      originalLanguage: String?, lastVolume: String?,
      lastChapter: String?, publicationDemographic: String?,
      status: String?, year: Int?, contentRating: String?, tags: [Tag]?,
      state: String?,chapterNumbersResetOnNewVolume: Bool?,
      createdAt: String?, updatedAt: String?, version: Int?,
      availableTranslatedLanguages: [String]?,
      latestUploadedChapter:String?
    ) {
      self.title = title
      self.altTitles = altTitles
      self.description = description
      self.isLocked = isLocked
      self.links = links
      self.originalLanguage = originalLanguage
      self.lastVolume = lastVolume
      self.lastChapter = lastChapter
      self.publicationDemographic = publicationDemographic
      self.status = status
      self.year = year
      self.contentRating = contentRating
      self.tags = tags
      self.state = state
      self.chapterNumbersResetOnNewVolume = chapterNumbersResetOnNewVolume
      self.createdAt = createdAt
      self.updatedAt = updatedAt
      self.version = version
      self.availableTranslatedLanguages = availableTranslatedLanguages
      self.latestUploadedChapter = latestUploadedChapter
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        title = try container.decode(Title.self, forKey: .title)
        altTitles = try container.decodeIfPresent([Title].self, forKey: .altTitles)
        description = try container.decodeIfPresent(Description.self, forKey: .description)
        isLocked = try container.decodeIfPresent(Bool.self, forKey: .isLocked)
        links = try container.decodeIfPresent([String: String].self, forKey: .links)
        originalLanguage = try container.decodeIfPresent(String.self, forKey: .originalLanguage)
        lastVolume = try container.decodeIfPresent(String.self, forKey: .lastVolume)
        lastChapter = try container.decodeIfPresent(String.self, forKey: .lastChapter)
        publicationDemographic = try container.decodeIfPresent(String.self, forKey: .publicationDemographic)
        status = try container.decodeIfPresent(String.self, forKey: .status)
        year = try container.decodeIfPresent(Int.self, forKey: .year)
        contentRating = try container.decodeIfPresent(String.self, forKey: .contentRating)
        tags = try container.decodeIfPresent([Tag].self, forKey: .tags)
        state = try container.decodeIfPresent(String.self, forKey: .state)
        chapterNumbersResetOnNewVolume = try container.decodeIfPresent(Bool.self, forKey: .chapterNumbersResetOnNewVolume)
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt)
        version = try container.decodeIfPresent(Int.self, forKey: .version)

        if let languages = try container.decodeIfPresent([String?].self, forKey: .availableTranslatedLanguages) {
            availableTranslatedLanguages = languages.compactMap { $0 }
        } else {
            availableTranslatedLanguages = nil
        }
        latestUploadedChapter = try container.decodeIfPresent(String.self, forKey: .latestUploadedChapter)
    }
}

