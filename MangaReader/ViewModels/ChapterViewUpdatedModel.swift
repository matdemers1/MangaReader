//
// Created by Matthew Demers on 12/29/23.
//

import Foundation
//
// Created by Matthew Demers on 12/2/23.
//

import Foundation
import SwiftUI

class ChapterViewUpdatedModel: ObservableObject {
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

  // Setting up the threads for the image loading
  private let imageLoadQueue = DispatchQueue(label: "imageLoadQueue", attributes: .concurrent)
  private let downloadSemaphore = DispatchSemaphore(value: 8)  // Limit to 8 concurrent downloads

  func clearImages() {
    images.removeAll()
    totalPagesLoaded = 0
    loadingProgress = 0
    averageDownloadSpeed = 0
    elapsedTime = 0
    estimatedTimeToCompletion = 0
  }

  func fetchChapterData(chapterId: String, dataType: DataTypes, completion: @escaping (AtHomeResponse?) -> Void) {
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
            self?.loadImages(atHomeResponse: response, dataType: dataType)
            self?.isLoadingChapterData = false
            completion(response)
          }
        }.resume()
  }

  func loadImages(atHomeResponse: AtHomeResponse, dataType: DataTypes) {
    let totalImages = atHomeResponse.chapter.data.count

    // Start timer for download
    downloadStartTime = Date()

    // Reset current index before starting loading
    currentIndexLoading = 0
    loadNextImage(atHomeResponse: atHomeResponse, dataType: dataType, totalImages: totalImages)
  }

  private func loadNextImage(atHomeResponse: AtHomeResponse, dataType: DataTypes, totalImages: Int) {
    self.downloadSemaphore.wait()  // Wait for a free slot

    guard currentIndexLoading < atHomeResponse.chapter.data.count else {
      self.downloadSemaphore.signal()  // Important to signal even if no download is happening
      return
    }

    let pageUrl = dataType == .data ? atHomeResponse.chapter.data[currentIndexLoading] :
        atHomeResponse.chapter.dataSaver[currentIndexLoading]
    let url = getChapterUrl(atHomeResponse: atHomeResponse, pageUrl: pageUrl, dataType: dataType)

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
          self?.loadNextImage(atHomeResponse: atHomeResponse, dataType: dataType, totalImages: totalImages)
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

  func getChapterUrl(atHomeResponse: AtHomeResponse, pageUrl: String, dataType: DataTypes) -> URL {
    let url = "\(atHomeResponse.baseUrl)/\(dataType == .dataSaver ? "data-saver" : "data")/\(atHomeResponse.chapter.hash)/\(pageUrl)"
    return URL(string: url)!
  }

  func loadImagesSequentially(atHomeResponse: AtHomeResponse?, dataType: DataTypes) {
    // Clear existing images
    images.removeAll()

    guard let atHomeResponse = atHomeResponse else {
      return
    }

    let totalImages = atHomeResponse.chapter.data.count
    let initialLoadCount = min(5, totalImages)

    // Load the initial set of images
    for index in 0..<initialLoadCount {
      loadImageForIndex(atHomeResponse: atHomeResponse, dataType: dataType, index: index, totalImages: totalImages)
    }
  }

  private func loadImageForIndex(atHomeResponse: AtHomeResponse, dataType: DataTypes, index: Int, totalImages: Int) {
    guard index < totalImages else {
      return // Exit if index is out of range
    }

    let pageUrl = dataType == .data ? atHomeResponse.chapter.data[index] :
        atHomeResponse.chapter.dataSaver[index]
    let url = getChapterUrl(atHomeResponse: atHomeResponse, pageUrl: pageUrl, dataType: dataType)

    // Load the image
    loadImage(from: url) { [weak self] image in
      DispatchQueue.main.async {
        self?.images[url] = image
        self?.totalPagesLoaded += 1
        self?.loadingProgress = Float(self?.totalPagesLoaded ?? 0) / Float(totalImages)
        self?.updateDownloadStats()
      }
    }
  }

  func loadCurrentNextLastImages(currentIndex: Int, atHomeResponse: AtHomeResponse?, dataType: DataTypes) {
    print("Loading current, next, and last images")
    dump(atHomeResponse)
    guard let atHomeResponse = atHomeResponse else {
      return
    }
    print("Current index: \(currentIndex)")
    // Clear images that are not within the range of currentIndex - 1, currentIndex, currentIndex + 1
    images = images.filter { url, _ in
      guard let index = atHomeResponse.chapter.data.firstIndex(of: url.absoluteString) else {
        return false
      }
      return index >= currentIndex - 1 && index <= currentIndex + 1
    }

    // Load images for current, next, and last pages
    print("Loading images for current, next, and last pages")
    let totalImages = atHomeResponse.chapter.data.count
    [currentIndex - 1, currentIndex, currentIndex + 1].forEach { index in
      if shouldLoadImageForIndex(index: index, totalImages: totalImages, atHomeResponse: atHomeResponse, dataType: dataType) {
        loadSingleImageForIndex(atHomeResponse: atHomeResponse, dataType: dataType, index: index, totalImages: totalImages)
      }
    }
  }

  private func shouldLoadImageForIndex(index: Int, totalImages: Int, atHomeResponse: AtHomeResponse, dataType: DataTypes) -> Bool {
    guard index >= 0 && index < totalImages else {
      return false // Index is out of range
    }

    let pageUrl = atHomeResponse.chapter.data[index]
    let url = getChapterUrl(atHomeResponse: atHomeResponse, pageUrl: pageUrl, dataType: dataType)

    return images[url] == nil // Return true if the image is not already loaded
  }

  private func loadSingleImageForIndex(atHomeResponse: AtHomeResponse, dataType: DataTypes, index: Int, totalImages: Int) {
    guard index >= 0 && index < totalImages else {
      return // Exit if index is out of range
    }

    let pageUrl = dataType == .data ? atHomeResponse.chapter.data[index] :
        atHomeResponse.chapter.dataSaver[index]
    let url = getChapterUrl(atHomeResponse: atHomeResponse, pageUrl: pageUrl, dataType: dataType)

    // Load the image
    loadImage(from: url) { [weak self] image in
      DispatchQueue.main.async {
        self?.images[url] = image
        self?.loadingProgress = Float(self?.totalPagesLoaded ?? 0) / Float(totalImages)
        self?.updateDownloadStats()
      }
    }
  }
}
