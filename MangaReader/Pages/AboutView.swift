//
// Created by Matthew Demers on 12/25/23.
//

import Foundation
import SwiftUI



struct AboutView: View {
    var body: some View {
        VStack {
          // Center the app icon
          Text("MangaUI")
              .font(.title)
              .padding(.bottom, 8)
          Text("Version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")")
              .font(.title3)
              .padding(.bottom, 8)
          Text("Created by Matthew Demers")
              .font(.caption)
              .padding(.bottom, 8)
//          Text("All user data including favorites and reading list will be stored locally on your device. No data will be sent to any server.")
//              .font(.body)
//              .foregroundColor(.secondary)
//              .padding(.horizontal)
//              .padding(.bottom, 8)
          ScrollView {
            Text("Welcome to MangaUI, where the fascinating world of manga is at your fingertips. As you embark on this journey through countless stories, it's important to acknowledge the incredible work and dedication of those who make this experience possible.")
                .withBodyStyle()
            Text("A Heartfelt Thank You to MangaDex and Scanlation Groups")
                .withBodyHeaderStyle()
            Text("At the core of MangaUI is the vast and diverse library of manga, made accessible through the powerful MangaDex API. MangaDex has been instrumental in bridging the gap between manga creators and readers worldwide. Their commitment to providing a comprehensive platform for manga enthusiasts is what inspires and drives us.")
                .withBodyStyle()
            Text("We also extend our deepest gratitude to the global community of scanlation groups. These teams of translators, editors, and artists work tirelessly to bring manga to life in languages accessible to a global audience. Their passion and dedication are truly the backbone of the international manga community. Without their efforts, the rich diversity of manga would remain out of reach for many.")
                .withBodyStyle()
            Text("Our Commitment to the Manga Community")
                .withBodyHeaderStyle()
            Text("As a developer, primarily from a web development background venturing into the realm of iOS apps, creating MangaUI has been a journey of passion and learning. This app is a tribute to the art of manga and everyone who contributes to its global reach. It's an ongoing endeavor, and we are committed to continuously enhancing MangaUI to provide the best possible experience to our users.")
                .withBodyStyle()
            Text("Together, Celebrating the Art of Manga")
                .withBodyHeaderStyle()
            Text("MangaUI is more than just an app; it's a community of manga lovers. Every page you turn, every story you dive into is a celebration of the artistry and hard work of manga creators and the scanlation community.")
                .withBodyStyle()
            Text("Thank you for choosing MangaUI as your gateway to the wonderful world of manga. Your support and feedback are invaluable as we strive to make this app better every day.")
                .withBodyStyle()
            Text("Happy reading!")
                .withBodyHeaderStyle()
          }
        }
            .padding()
    }
}

