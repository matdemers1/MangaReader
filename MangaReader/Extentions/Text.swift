//
//  Text.swift
//  MangaReader
//
//  Created by Matthew Demers on 11/28/23.
//

import Foundation
import SwiftUI

extension Text {
    func withPillStyle() -> some View {
        self.font(.caption2)
            .padding(5)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
    }
}

