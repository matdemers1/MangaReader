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
            // Assuming you want to display the count for "none" volume
            self?.chapterCount = response.volumes["none"]?.count
          case .failure(let error):
            print(error) // Handle the error appropriately
        }
      }
    }
  }
}
