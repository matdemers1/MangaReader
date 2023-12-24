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
  private var currentIndexLoading: Int = 0

  //Setting up the threads for the image loading
  private let imageLoadQueue = DispatchQueue(label: "imageLoadQueue", attributes: .concurrent)
  private let downloadSemaphore = DispatchSemaphore(value: 8)  // Limit to 2 concurrent downloads

  func clearImages() {
    images.removeAll()
    totalPagesLoaded = 0
    loadingProgress = 0
    averageDownloadSpeed = 0
    elapsedTime = 0
    estimatedTimeToCompletion = 0
  }

  func fetchChapterData(chapterId: String, completion: @escaping (AtHomeResponse?) -> Void) {
    print("Fetching chapter data for \(chapterId)")
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
              print("Error code \(String(describing: error?._code)): fetching chapter data: \(error?.localizedDescription ?? "Unknown error")")
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

    // Start timer for download
    downloadStartTime = Date()

    // Reset current index before starting loading
    currentIndexLoading = 0
    loadNextImage(atHomeResponse: atHomeResponse, totalImages: totalImages)
  }

  private func loadNextImage(atHomeResponse: AtHomeResponse, totalImages: Int) {
    self.downloadSemaphore.wait()  // Wait for a free slot

    guard currentIndexLoading < atHomeResponse.chapter.data.count else {
      self.downloadSemaphore.signal()  // Important to signal even if no download is happening
      return
    }

    let pageUrl = atHomeResponse.chapter.data[currentIndexLoading]
    let url = getChapterUrl(atHomeResponse: atHomeResponse, chapterId: pageUrl)

    currentIndexLoading += 1  // Increment before the async call

    imageLoadQueue.async { [weak self] in
      self?.loadImage(from: url) { image in
        DispatchQueue.main.async {
          self?.images[url] = image
          self?.totalPagesLoaded += 1
          self?.loadingProgress = Float(self?.totalPagesLoaded ?? 0) / Float(totalImages)
          self?.updateDownloadStats()

          self?.downloadSemaphore.signal()  // Signal completion

          // Call the next image load on the main thread to avoid race conditions
          self?.loadNextImage(atHomeResponse: atHomeResponse, totalImages: totalImages)
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
