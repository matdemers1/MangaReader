//
//  Aggeragate.swift
//  MangaReader
//
//  Created by Matthew Demers on 2/16/24.
//

import Foundation

// Defines the root of the JSON structure
struct ApiResponse: Codable {
  let result: String
  let volumes: [String: Volume]
}

// Represents volume information including chapters
struct Volume: Codable {
  let volume: String
  let count: Int
  let chapters: [String: AggChapter]
}

struct AggChapter: Codable {
  let chapter: String
  let id: String
  let others: [String] // Assuming `others` is an array of strings. Adjust based on actual data.
  let count: Int
}

func fetchMangaAggregate(mangaId: String, completion: @escaping (Result<ApiResponse, Error>) -> Void) {
  let urlString = "https://api.mangadex.org/manga/\(mangaId)/aggregate?translatedLanguage[]=en"
  guard let url = URL(string: urlString) else {
    completion(.failure(NSError(domain: "InvalidURL", code: 0, userInfo: nil)))
    return
  }
  
  let task = URLSession.shared.dataTask(with: url) { data, response, error in
    if let error = error {
      completion(.failure(error))
      return
    }
    
    guard let data = data else {
      completion(.failure(NSError(domain: "NoData", code: 0, userInfo: nil)))
      return
    }
    
    do {
      let apiResponse = try JSONDecoder().decode(ApiResponse.self, from: data)
      completion(.success(apiResponse))
    } catch {
      completion(.failure(error))
    }
  }
  
  task.resume()
}
