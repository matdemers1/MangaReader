//
// Created by Matthew Demers on 12/2/23.
//

import Foundation
import SwiftUI

class ChapterViewModel: ObservableObject {
  @Published var images: [URL: UIImage?] = [:]
  @Published var loadingProgress: Float = 0
  @Published var isLoadingChapterData = true
  @Published var errorMessage: String?

  // Additional variables
  @Published var totalPagesLoaded: Int = 0
  @Published var averageDownloadSpeed: Double = 0 // in bytes per second
  @Published var elapsedTime: TimeInterval = 0
  @Published var estimatedTimeToCompletion: TimeInterval = 0

  private var downloadStartTime: Date?
  private var totalDownloadSize: Int = 0
  private var totalDownloadTime: TimeInterval = 0

  func fetchChapterData(chapterId: String, completion: @escaping (AtHomeResponse?) -> Void) {
    guard let url = URL(string: "https://api.mangadex.org/at-home/server/\(chapterId.lowercased())") else {
      errorMessage = "Invalid URL for chapter data"
      return
    }


    URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
          if let error = error {
            DispatchQueue.main.async {
              self?.errorMessage = "Fetch Error: \(error.localizedDescription)"
              completion(nil)
            }
            return
          }
          guard let data = data, error == nil, let response = try? JSONDecoder().decode(AtHomeResponse.self, from: data) else {
            print("Error code \(error?._code): fetching chapter data: \(error?.localizedDescription ?? "Unknown error")")
            DispatchQueue.main.async {
              completion(nil)
            }
            return
          }

          DispatchQueue.main.async {
            self?.loadImages(atHomeResponse: response)
            self?.isLoadingChapterData = false
            completion(response)
          }
        }.resume()
  }

  func loadImages(atHomeResponse: AtHomeResponse) {
    let totalImages = atHomeResponse.chapter.data.count
    var loadedImages = 0

    // Start timer for download
    downloadStartTime = Date()

    atHomeResponse.chapter.data.forEach { pageUrl in
      let url = getChapterUrl(atHomeResponse: atHomeResponse, chapterId: pageUrl)
      loadImage(from: url) { image in
        DispatchQueue.main.async {
          self.images[url] = image
          loadedImages += 1
          self.loadingProgress = Float(loadedImages) / Float(totalImages)
          self.totalPagesLoaded = loadedImages
          self.updateDownloadStats()
        }
      }
    }
  }

  private func updateDownloadStats() {
    let currentTime = Date()
    elapsedTime = currentTime.timeIntervalSince(downloadStartTime ?? currentTime)

    if totalPagesLoaded > 0 {
      averageDownloadSpeed = Double(totalDownloadSize) / totalDownloadTime
      let remainingImages = images.count - totalPagesLoaded
      estimatedTimeToCompletion = (totalDownloadTime / Double(totalPagesLoaded)) * Double(remainingImages)
    }
  }

  private func loadImage(from url: URL, retryCount: Int = 3, completion: @escaping (UIImage?) -> Void) {
    let startTime = Date()

    // Custom configuration with increased timeout
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 30  // 30 seconds timeout
    let session = URLSession(configuration: configuration)

    session.dataTask(with: url) { [weak self] data, response, error in
          if let error = error {
            if (retryCount > 0) && (error as NSError).code == NSURLErrorTimedOut {
              print("Retrying image download: \(url)")
              self?.loadImage(from: url, retryCount: retryCount - 1, completion: completion)
            } else {
              DispatchQueue.main.async {
                self?.errorMessage = "Image Download Error: \(error.localizedDescription)"
                completion(nil)
              }
            }
            return
          }

          guard let data = data else {
            DispatchQueue.main.async {
              completion(nil)
            }
            return
          }

          let downloadTime = Date().timeIntervalSince(startTime)
          self?.totalDownloadTime += downloadTime
          self?.totalDownloadSize += data.count

          if let image = UIImage(data: data) {
            DispatchQueue.main.async {
              completion(image)
            }
          } else {
            DispatchQueue.main.async {
              self?.errorMessage = "Error: Could not decode image data"
              completion(nil)
            }
          }
        }.resume()
  }

}

func getChapterUrl(atHomeResponse: AtHomeResponse, chapterId: String) -> URL {
  let url = "\(atHomeResponse.baseUrl)/data/\(atHomeResponse.chapter.hash)/\(chapterId)"
  return URL(string: url)!
}
