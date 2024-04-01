//
//  MangaCardViewModel.swift
//  MangaReader
//
//  Created by Matthew Demers on 2/16/24.
//

import Foundation
class MangaCardViewModel: ObservableObject {
  @Published var chapterCount: Int? = nil // Example data to display
  
  func fetchAggregateData(forMangaId mangaId: String) {
    fetchMangaAggregate(mangaId: mangaId) { [weak self] result in
      DispatchQueue.main.async {
        switch result {
          case .success(let response):
            let totalCount = response.volumes.reduce(0) { (count, volumeEntry) -> Int in
              let (_, volume) = volumeEntry
              return count + volume.count
            }
            self?.chapterCount = totalCount
          case .failure(let error):
            print(error) // Handle the error appropriately
        }
      }
    }
  }
}
