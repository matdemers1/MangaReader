//
// Created by Matthew Demers on 12/14/23.
//

import Foundation
import SwiftUI

struct SplashScreenView: View {
  var body: some View {
    VStack {
      Text("Manga Reader")
          .font(.largeTitle)
          .fontWeight(.bold)
      Text("Powered by MangaDex")
          .font(.title2)
          .fontWeight(.semibold)
      // Add more design as per your requirement
        Image(.splashScreenIcon)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 400, height: 400)
    }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
  }
}
