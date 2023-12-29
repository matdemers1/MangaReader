//
// Created by Matthew Demers on 12/29/23.
//

import Foundation
import SwiftUI

struct SinglePageView: View {
  var orderedImages: () -> [UIImage]

  @State private var currentPage = 0
  private var images: [UIImage] { orderedImages() }

  var body: some View {
    VStack {
      // Page Indicator
      if !images.isEmpty {
        Text("Page \(currentPage + 1) of \(images.count)")
            .font(.headline)
            .padding(.top)
      }

      // Manga Pages
      if !images.isEmpty {
        TabView(selection: $currentPage) {
          ForEach(images.indices, id: \.self) { index in
            Image(uiImage: images[index])
                .resizable()
                .scaledToFit()
                .tag(index)
          }
        }
            .tabViewStyle(PageTabViewStyle())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
  }
}

