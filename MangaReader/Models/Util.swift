//
//  Util.swift
//  MangaReader
//
//  Created by Matthew Demers on 11/28/23.
//

import Foundation

// Relationship to other entities (e.g., related manga)
struct Relationship: Codable, Identifiable, Equatable, Hashable {
    let id: UUID
    let type: String
    let related: String?
    let attributes: RelationshipAttributes?
}

struct RelationshipAttributes: Codable, Equatable, Hashable {
    let name: String?
    let altNames: [LocalizedNames]?
    let locked: Bool?
    let website: String?
    let ircServer: String?
    let ircChannel: String?
    let discord: String?
    let contactEmail: String?
    let description: String?
    let twitter: String?
    let mangaUpdates: String?
    let focusedLanguages: [String]?
    let official: Bool?
    let verified: Bool?
    let inactive: Bool?
    let publishDelay: String?
    let exLicensed: Bool?
    let createdAt: String?
    let updatedAt: String?
    let version: Int?
    let fileName: String?

}


struct Title: Codable {
    var localizedTitles: [String: String]

    subscript(key: String) -> String? {
        return localizedTitles[key]
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.localizedTitles = try container.decode([String: String].self)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(localizedTitles)
    }
}


struct Description: Codable {
    var localizedDescriptions: [String: String]

    subscript(key: String) -> String? {
        return localizedDescriptions[key]
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.localizedDescriptions = try container.decode([String: String].self)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(localizedDescriptions)
    }
}

struct LocalizedNames: Codable, Equatable, Hashable {
    var names: [String: String]

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.names = try container.decode([String: String].self)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(names)
    }
}

