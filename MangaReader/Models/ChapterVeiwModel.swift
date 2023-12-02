//
// Created by Matthew Demers on 12/2/23.
//

import Foundation
import SwiftUI

class ChapterViewModel: ObservableObject {
  @Published var images: [URL: UIImage?] = [:]
  @Published var loadingProgress: Float = 0
  @Published var isLoadingChapterData = true

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

    atHomeResponse.chapter.data.forEach { pageUrl in
      let url = getChapterUrl(atHomeResponse: atHomeResponse, chapterId: pageUrl)
      loadImage(from: url) { image in
        DispatchQueue.main.async {
          self.images[url] = image
          loadedImages += 1
          self.loadingProgress = Float(loadedImages) / Float(totalImages)
        }
      }
    }
  }

  private func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
    URLSession.shared.dataTask(with: url) { data, response, error in
          guard let data = data, error == nil else {
            print("Error downloading image: \(error?.localizedDescription ?? "Unknown error")")
            DispatchQueue.main.async {
              completion(nil)
            }
            return
          }

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
