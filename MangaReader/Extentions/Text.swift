//
//  Text.swift
//  MangaReader
//
//  Created by Matthew Demers on 11/28/23.
//

import Foundation
import SwiftUI

extension Text {
    func withPillStyle( color: Color ) -> some View {
        self.font(.caption)
            .padding(.vertical, 4)
            .padding(.horizontal, 6)
            .foregroundColor(color)
            .cornerRadius(4)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(color, lineWidth: 1)
            )
    }

    func withBodyStyle() -> some View {
        self.font(.body)
            .padding(.vertical, 4)
            .padding(.horizontal, 6)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    func withBodyHeaderStyle() -> some View {
        self.font(.body.bold())
            .padding(.vertical, 4)
            .padding(.horizontal, 6)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.accentColor)
    }
}

