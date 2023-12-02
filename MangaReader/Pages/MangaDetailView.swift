//
//  MangaDetailView.swift
//  MangaReader
//
//  Created by Matthew Demers on 11/28/23.
//

import Foundation
import SwiftUI

struct MangaDetailView: View {
    let manga: Manga
    let chaptersResponse: ChapterResponse?
    let chapters: [Chapter]?
    
    init(manga: Manga) {
        self.manga = manga
        self.chaptersResponse = loadMockChapterResponse()
        self.chapters = chaptersResponse?.data
    }

    var body: some View {
        ScrollView() {
            VStack(spacing: 0) {
                ZStack(alignment:.bottomLeading){
                    GeometryReader { geometry in
                        if let coverArtURL = manga.coverArt?.fullCoverURL {
                            AsyncImage(url: URL(string: coverArtURL)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: geometry.size.width)
                                    .frame(height: geometry.size.height/1)
                            } placeholder: {
                                ProgressView()
                            }
                        }
                    }
                    LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom)
                        .frame(height: 480)
                    
                    // Title and Artist name
                    VStack(alignment: .leading){
                        Text(manga.attributes.title["en"] ?? "Unknown Title")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(.top, 20)
                        
                        Text("Artist Placeholder")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    
                }
                // Manga Details
                VStack(alignment: .leading, spacing: 8) {
                    ExpandableText(manga.attributes.description?["en"] ?? "No description", lineLimit: 6)
                        .foregroundColor(.white)
                        .padding()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.black)
                VStack(alignment: .leading){
                    Text("Chapters")
                        .font(.subheadline)
                    if let chapters = chapters {
                        ForEach(chapters, id: \.id){ chapter in
                            NavigationLink(destination: ChapterView(chapterId: chapter.id.description)) {
                                HStack(alignment: .center){
                                    Image(systemName: "eye")
                                    VStack(alignment: .leading) {
                                        Text("Chapter \(chapter.attributes.chapter ?? "N/A")")
                                            .font(.headline)
                                        Text(chapter.attributes.title ?? "No Title")
                                            .font(.subheadline)
                                    }
                                    Spacer()
                                }
                                Divider()
                            }
                        }
                    } else {
                        Text("No chapters available")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
        }
    }
    
}

#Preview {
    MangaDetailView(manga: loadMockSingleData())
        .modelContainer(for: Item.self, inMemory: true)
        .colorScheme(.dark)
}

