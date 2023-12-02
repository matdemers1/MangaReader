//
//  Chapter.swift
//  MangaReader
//
//  Created by Matthew Demers on 11/29/23.
//

import Foundation

// Struct to represent each chapter
struct Chapter: Codable, Identifiable {
    let id: UUID
    let type: String
    let attributes: ChapterAttributes
    let relationships: [Relationship]
}

// Attributes specific to a chapter
struct ChapterAttributes: Codable {
    let title: String?
    let volume: String?
    let chapter: String?
    let pages: Int
    let translatedLanguage: String
    let uploader: UUID?
    let externalUrl: String?
    let version: Int
    let createdAt: String
    let updatedAt: String
    let publishAt: String
    let readableAt: String
}

