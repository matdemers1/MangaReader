//
// Created by Matthew Demers on 12/2/23.
//
import Foundation
import UIKit

enum ViewType {
  case singlePage
  case longStrip
}

enum DataTypes {
  case data
  case dataSaver
}

class ChapterViewModel: ObservableObject {
  @Published var images: [URL: UIImage?] = [:]
  @Published var loadingProgress: Float = 0
  @Published var isLoadingChapterData = true
  @Published var errorMessage: String?
  @Published var totalPagesLoaded: Int = 0

  private var downloadTasks: [URLSessionDataTask] = []

  func fetchChapterData(chapterId: String, dataType: DataTypes, completion: @escaping (AtHomeResponse?) -> Void) {
    isLoadingChapterData = true  // Indicate loading is in progress
    images = [:]  // Clear images from previous chapter
    totalPagesLoaded = 0  // Reset total pages loaded
    loadingProgress = 0  // Reset loading progress
    errorMessage = nil  // Clear any previous error messages

    guard let url = URL(string: "https://api.mangadex.org/at-home/server/\(chapterId.lowercased())") else {
      errorMessage = "Invalid URL for chapter data"
      isLoadingChapterData = false
      completion(nil)
      return
    }

    let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
      guard let self = self else { return }

      DispatchQueue.main.async {
        if let data = data, error == nil, let response = try? JSONDecoder().decode(AtHomeResponse.self, from: data) {
          self.loadImages(atHomeResponse: response, dataType: dataType)
          self.isLoadingChapterData = false  // Stop loading indication on success
          completion(response)
        } else {
          self.errorMessage = "Fetch Error: \(error?.localizedDescription ?? "Unknown error")"
          self.isLoadingChapterData = false  // Stop loading indication on error
          completion(nil)
        }
      }
    }

    task.resume()
  }


  private func loadImages(atHomeResponse: AtHomeResponse, dataType: DataTypes) {
    let pageUrls = dataType == .data ? atHomeResponse.chapter.data : atHomeResponse.chapter.dataSaver
    let totalImages = pageUrls.count
    for pageUrl in pageUrls {
      loadImage(url: pageUrl, atHomeResponse: atHomeResponse, dataType: dataType, totalImages: totalImages)
    }
  }

  private func loadImage(url: String, atHomeResponse: AtHomeResponse, dataType: DataTypes, totalImages: Int) {
    guard let imageUrl = URL(string: "\(atHomeResponse.baseUrl)/\(dataType == .dataSaver ? "data-saver" : "data")/\(atHomeResponse.chapter.hash)/\(url)") else { return }

    let task = URLSession.shared.dataTask(with: imageUrl) { [weak self] data, _, error in
      guard let data = data, error == nil, let image = UIImage(data: data) else {
        DispatchQueue.main.async {
          self?.errorMessage = "Image Download Error: \(error?.localizedDescription ?? "Unknown error")"
        }
        return
      }

      DispatchQueue.main.async {
        self?.images[imageUrl] = image
        self?.totalPagesLoaded += 1
        self?.loadingProgress = Float(self?.totalPagesLoaded ?? 0) / Float(totalImages)
      }
    }

    task.resume()
    downloadTasks.append(task)
  }

  deinit {
    downloadTasks.forEach { $0.cancel() }
  }

  func getChapterUrl(atHomeResponse: AtHomeResponse, pageUrl: String, dataType: DataTypes) -> URL {
    let url = "\(atHomeResponse.baseUrl)/\(dataType == .dataSaver ? "data-saver" : "data")/\(atHomeResponse.chapter.hash)/\(pageUrl)"
    return URL(string: url)!
  }
}
