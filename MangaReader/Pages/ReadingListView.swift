//
// Created by Matthew Demers on 12/13/23.
//

import Foundation
//
// Created by Matthew Demers on 12/7/23.
//

import Foundation
import SwiftData
import SwiftUI

struct ReadingListView: View {
  let titleFont: Font

  @Environment(\.modelContext) private var modelContext
  @Query private var readingListGroups: [ReadingListGroup]
  @State private var showAddGroup = false
  @State private var name = ""
  @State private var expandedGroups: Set<UUID> = []  // New state to track expanded groups

  var body: some View {
    NavigationStack {
      VStack {
        HStack {
          Text("Reading List")
               .font(titleFont )
              .padding()
          Spacer()
          Button(action: {
            showAddGroup.toggle()
          }, label: {
            Image(systemName: "plus")
                .font(.system(size: 20))
          })
              .padding()
              .bold()
              .alert("Create a new Group", isPresented: $showAddGroup) {
                TextField("Enter your name", text: $name)
                Button("OK", action: createNewGroup)
                Button("Cancel", role: .cancel) {
                  showAddGroup.toggle()
                }
              } message: {
                Text("Enter the name of the new group")
              }
        }
            .frame(maxWidth: .infinity, alignment: .leading)
        List {
          ForEach(readingListGroups, id: \.self) { entry in
            Section(
                header: HStack {
                  Text(entry.groupName)
                      .fontWeight(.semibold)
                  Spacer()
                  // Chip showing the item count
                  Text("\(entry.readingListItems.count) mangas")
                      .font(.caption)
                      .padding(5)
                      .background(Color.blue)
                      .foregroundColor(.white)
                      .cornerRadius(10)
                  // Arrow indicator
                  Image(systemName: "chevron.right")
                      .rotationEffect(.degrees(expandedGroups.contains(entry.groupId) ? 90 : 0))
                      .animation(.easeInOut, value: expandedGroups.contains(entry.groupId))
                }
                    .cornerRadius(8)
                    .contentShape(Rectangle())
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                      withAnimation {
                        if expandedGroups.contains(entry.groupId) {
                          expandedGroups.remove(entry.groupId)
                        } else {
                          expandedGroups.insert(entry.groupId)
                        }
                      }
                    }
            ) {
              if expandedGroups.contains(entry.groupId) {
                ForEach(entry.readingListItems, id: \.self) { item in
                  NavigationLink(destination: MangaDetailView(mangaId: item.mangaId)) {
                    Text(item.mangaName)
                  }
                }
              }
            }
          }
              .onDelete(perform: deleteReadingGroup)
        }
            .listStyle(.sidebar)

      }
    }
  }

  func deleteReadingGroup(at offsets: IndexSet) {
    for index in offsets {
      let entry = readingListGroups[index]
      modelContext.delete(entry)
    }
  }

  func createNewGroup() {
    let newGroup = ReadingListGroup(groupId: UUID(), groupName: name)
    modelContext.insert(newGroup)
    name = ""
  }
}
