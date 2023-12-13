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
  @Environment(\.modelContext) private var modelContext
  @Query private var readingListGroups: [ReadingListGroup]
  @State private var showAddGroup = false
  @State private var name = ""

  var body: some View {
    VStack {
      HStack {
        Text("Reading List")
            .font(.largeTitle.bold())
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
            .alert("Create a new Group", isPresented: $showAddGroup){
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
          Section(header: Text(entry.groupName)) {
            ForEach(entry.readingListItems, id: \.self) { item in
              NavigationLink(destination: MangaDetailView(mangaId: item.mangaId)) {
                Text(item.mangaName)
              }
            }
          }
        }
            .onDelete(perform: deleteReadingGroup)

      }
          .listStyle(.sidebar)
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
    try! modelContext.insert(newGroup)
    name = ""
  }
}