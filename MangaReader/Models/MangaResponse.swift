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
    let data: [Manga]
    let limit: Int
    let offset: Int
    let total: Int
}
