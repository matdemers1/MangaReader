//
//  Manga.swift
//  MangaReader
//
//  Created by Matthew Demers on 11/28/23.
//

import Foundation

struct Manga: Codable {
    let id: String
    let type: String
    let attributes: MangaAttributes
    let relationships: [Relationship]
}

extension Manga {
    var coverArt: MangaCoverArt? {
        if let coverArt = relationships.first(where: { $0.type == "cover_art" }),
           let fileName = coverArt.attributes?.fileName {
            return MangaCoverArt(mangaID: id, fileName: fileName)
        }
        return nil
    }
}


func loadMockData() -> [Manga] {
    guard let url = Bundle.main.url(forResource: "MockMangaData", withExtension: "json") else {
        fatalError("Missing file: MockMangaData.json")
    }

    do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let jsonData = try decoder.decode([Manga].self, from: data)
        return jsonData
    } catch {
        print("Error loading mock data: \(error)")
        fatalError("Error loading mock data: \(error)")
    }
}

func loadMockSingleData() -> Manga {
    guard let url = Bundle.main.url(forResource: "MockSingleData", withExtension: "json") else {
        fatalError("Missing file: MockMangaData.json")
    }

    do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let jsonData = try decoder.decode(Manga.self, from: data)
        return jsonData
    } catch {
        print("Error loading mock data: \(error)")
        fatalError("Error loading mock data: \(error)")
    }
}
