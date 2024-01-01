//
// Created by Matthew Demers on 12/20/23.
//

import Foundation
import SwiftUI

struct ScanlationGroupView: View {
    var groupData: RelationshipAttributes

    var body: some View {
        VStack(alignment: .leading) {
            Text(groupData.name ?? "Unknown")
                .font(.title.bold())
            if groupData.official ?? false || groupData.verified ?? false || groupData.inactive ?? false {
                HStack(alignment: .top) {
                    if let isOfficial = groupData.official {
                        if isOfficial {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text("Official")
                            }
                        }
                    }
                    if let isVerified = groupData.verified {
                        if isVerified {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.purple)
                                Text("Verified")
                            }
                        }
                    }
                    if let isInactive = groupData.inactive {
                        if isInactive {
                            HStack {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                                Text("Inactive")
                            }
                        }
                    }
                }
                    .padding(1)
            }
            Divider()
            ScrollView {
                ExpandableText(groupData.description ?? "No description available.", lineLimit: 6)
                    .foregroundColor(.secondary)
                    .font(.caption)
                Divider()
                VStack {
                    if groupData.focusedLanguages != nil && groupData.focusedLanguages != [] {
                        Text("Focused Languages: \(groupData.focusedLanguages?.joined(separator: ", ") ?? "Unknown")")
                    }
                    if groupData.publishDelay != nil && groupData.publishDelay != "" {
                        Text("Publish Delay: \(groupData.publishDelay ?? "Unknown")")
                    }
                    if groupData.exLicensed != nil {
                        if groupData.exLicensed! {
                            Text("Licensed: Yes")
                        } else {
                            Text("Licensed: No")
                        }
                    }
                }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                Divider()
                VStack {
                    if groupData.website != nil && groupData.website != "" {
                        Link(destination: URL(string: groupData.website ?? "https://mandex.org")!) {
                            Image(systemName: "globe")
                            Text("Official Website")
                        }
                    }
                    if groupData.ircServer != nil && groupData.ircServer != "" {
                        Link(destination: URL(string: "irc://\(groupData.ircServer ?? "irc.rizon.net")/\(groupData.ircChannel ?? "mangadex")")!) {
                            Image(systemName: "bubble.left.and.bubble.right")
                            Text("IRC Channel")
                        }
                    }
                    if groupData.discord != nil && groupData.discord != "" {
                        Link(destination: URL(string: groupData.discord ?? "https://discord.gg/mandex")!) {
                            Image(systemName: "bubble.left.and.bubble.right")
                            Text("Discord Server")
                        }
                    }
                    if groupData.contactEmail != nil && groupData.contactEmail != "" {
                        Link(destination: URL(string: "mailto:\(groupData.contactEmail ?? "")")!) {
                            Image(systemName: "envelope")
                            Text("Contact Email")
                        }
                    }
                    if groupData.twitter != nil && groupData.twitter != "" {
                        Link(destination: URL(string: "https://twitter.com/\(groupData.twitter ?? "")")!) {
                            Image(systemName: "link")
                            Text("Twitter")
                        }
                    }
                    if groupData.mangaUpdates != nil && groupData.mangaUpdates != "" {
                        Link(destination: URL(string: "https://www.mangaupdates.com/groups.html?id=\(groupData.mangaUpdates ?? "")")!) {
                            Image(systemName: "link")
                            Text("MangaUpdates")
                        }
                    }
                }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
            }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            Spacer()
        }
            .padding()
            .frame(width: .infinity, height: .infinity, alignment: .topLeading)
    }
}
