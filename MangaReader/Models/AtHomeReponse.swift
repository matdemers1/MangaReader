//
//  AtHomeReponse.swift
//  MangaReader
//
//  Created by Matthew Demers on 12/1/23.
//

import Foundation

struct ChapterImageList: Codable {
    let hash: String
    let data: [String]
    let dataSaver: [String]
}

struct AtHomeResponse: Codable {
    let result: String
    let baseUrl: String
    let chapter: ChapterImageList
}

func loadMockAtHomeResponse(chapterId: String) -> AtHomeResponse {
    guard let url = Bundle.main.url(forResource: "MockAtHomeResponse", withExtension: "json") else {
        fatalError("Missing file: MockAtHomeResponse.json")
    }

    do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let jsonData = try decoder.decode(AtHomeResponse.self, from: data)
        return jsonData
    } catch {
        print("Error loading mock data: \(error)")
        fatalError("Error loading mock data: \(error)")
    }
}
