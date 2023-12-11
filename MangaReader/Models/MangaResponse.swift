//
//  MangaResponse.swift
//  MangaReader
//
//  Created by Matthew Demers on 11/28/23.
//

import Foundation

struct MangaResponse: Codable {
    let result: String
    let response: String
    var data: [Manga]
    let limit: Int?
    let offset: Int?
    let total: Int?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        result = try container.decode(String.self, forKey: .result)
        response = try container.decode(String.self, forKey: .response)

        // Decode limit, offset, and total as optional integers
        limit = try container.decodeIfPresent(Int.self, forKey: .limit)
        offset = try container.decodeIfPresent(Int.self, forKey: .offset)
        total = try container.decodeIfPresent(Int.self, forKey: .total)

        // Check for single Manga object or an array of Manga
        if let singleManga = try? container.decode(Manga.self, forKey: .data) {
            data = [singleManga]
        } else {
            data = try container.decode([Manga].self, forKey: .data)
        }
    }
}


