import Foundation
import SwiftUI

struct SinglePageView: View {
  var orderedImages: () -> [UIImage]
  var navigateToNextPage: () -> Void  // Closure to handle navigation to the next page

  @State private var currentPage = 0
  private var images: [UIImage] { orderedImages() }

  var body: some View {
    VStack {
      // Page Indicator
      if !images.isEmpty {
        Text("Page \(currentPage + 1) of \(images.count + 1)") // +1 for the additional final page
            .font(.headline)
            .padding(.top)
      }

      // Manga Pages
      if !images.isEmpty {
        TabView(selection: $currentPage) {
          ForEach(0...(images.count), id: \.self) { index in
            if index < images.count {
              Image(uiImage: images[index])
                  .resizable()
                  .scaledToFit()
                  .tag(index)
            } else {
              // Final Page
              Button("Go to Next Chapter", action: navigateToNextPage)
                  .frame(maxWidth: .infinity, maxHeight: .infinity)
                  // Style the background to be black to purple hombre and the text to be white
                  .background(RadialGradient(
                      gradient: Gradient(colors: [.purple, .black]),
                      center: .trailing,
                      startRadius: 0,
                      endRadius: 500
                  ))
                  .foregroundColor(.white)
                  .font(.headline)
                  .tag(index)
            }
          }
        }
            .tabViewStyle(PageTabViewStyle())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
  }
}
