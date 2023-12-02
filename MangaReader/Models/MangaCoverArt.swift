//
//  MangaCoverArt.swift
//  MangaReader
//
//  Created by Matthew Demers on 11/28/23.
//

import Foundation

struct MangaCoverArt {
    let mangaID: String
    let fileName: String

    var fullCoverURL: String {
        return "https://uploads.mangadex.org/covers/\(mangaID)/\(fileName)"
    }

    var thumbnailURL256: String {
        return fullCoverURL + ".256.jpg"
    }

    var thumbnailURL512: String {
        return fullCoverURL + ".512.jpg"
    }
}
