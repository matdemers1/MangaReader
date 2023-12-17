//
// Created by Matthew Demers on 12/2/23.
//

import Foundation
import SwiftUI

class ChapterViewModel: ObservableObject {
  @Published var images: [URL: UIImage?] = [:]
  @Published var loadingProgress: Float = 0
  @Published var isLoadingChapterData = true

  // Additional variables
  @Published var totalPagesLoaded: Int = 0
  @Published var averageDownloadSpeed: Double = 0 // in bytes per second
  @Published var elapsedTime: TimeInterval = 0
  @Published var estimatedTimeToCompletion: TimeInterval = 0

  private var downloadStartTime: Date?
  private var totalDownloadSize: Int = 0
  private var totalDownloadTime: TimeInterval = 0

  func fetchChapterData(chapterId: String, completion: @escaping (AtHomeResponse?) -> Void) {
    guard let url = URL(string: "https://api.mangadex.org/at-home/server/\(chapterId.lowercased())") else { return }

    print("Fetching chapter data from \(url)")

    URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
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

  private func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
    let startTime = Date()
    URLSession.shared.dataTask(with: url) { data, response, error in
          guard let data = data, error == nil else {
            print("Error downloading image: \(error?.localizedDescription ?? "Unknown error")")
            DispatchQueue.main.async {
              completion(nil)
            }
            return
          }

          let downloadTime = Date().timeIntervalSince(startTime)
          self.totalDownloadTime += downloadTime
          self.totalDownloadSize += data.count

          let image = UIImage(data: data)
          DispatchQueue.main.async {
            completion(image)
          }
        }.resume()
  }
}

func getChapterUrl(atHomeResponse: AtHomeResponse, chapterId: String) -> URL {
  let url = "\(atHomeResponse.baseUrl)/data/\(atHomeResponse.chapter.hash)/\(chapterId)"
  return URL(string: url)!
}
