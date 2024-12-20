//
// Created by Matthew Demers on 12/12/23.
//

import Foundation
import SwiftUI

struct SkeletonBox: View {
  let height: CGFloat
  let width: CGFloat

  let primaryColor = Color(.init(gray: 0.9, alpha: 1.0))
  let secondaryColor  = Color(.init(gray: 0.8, alpha: 1.0))

  var body: some View {
    HStack(alignment: .top, spacing: 16) {
      secondaryColor
          .frame(width: width, height: height)
    }
        .cornerRadius(10)
  }
}