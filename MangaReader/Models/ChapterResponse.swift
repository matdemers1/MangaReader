//
//  ChapterResponse.swift
//  MangaReader
//
//  Created by Matthew Demers on 11/29/23.
//

import Foundation

struct ChapterResponse: Codable {
    let result: String
    let response: String
    let data: [Chapter]
    let limit: Int
    let offset: Int
    let total: Int
}

func loadMockChapterResponse() -> ChapterResponse? {
    guard let url = Bundle.main.url(forResource: "MockChapterResponse", withExtension: "json") else {
        print("Missing file: MockChapterResponse.json")
        return nil
    }

    do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()

        // Create a DateFormatter for ISO 8601 format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX" // Modify this format to match your JSON date format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        // Set the custom date format to the decoder
        decoder.dateDecodingStrategy = .formatted(dateFormatter)

        let jsonData = try decoder.decode(ChapterResponse.self, from: data)
        return jsonData
    } catch DecodingError.dataCorrupted(let context) {
        print("Data corrupted: \(context)")
    } catch DecodingError.keyNotFound(let key, let context) {
        print("Key '\(key.stringValue)' not found: \(context.debugDescription), codingPath: \(context.codingPath)")
    } catch DecodingError.valueNotFound(let type, let context) {
        print("Value '\(type)' not found: \(context.debugDescription), codingPath: \(context.codingPath)")
    } catch DecodingError.typeMismatch(let type, let context) {
        print("Type '\(type)' mismatch: \(context.debugDescription), codingPath: \(context.codingPath)")
    } catch {
        print("Error loading mock data: \(error.localizedDescription)")
    }
    return nil
}



