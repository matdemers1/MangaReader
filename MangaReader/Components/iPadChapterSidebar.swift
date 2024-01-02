//
// Created by Matthew Demers on 1/1/24.
//

import Foundation
import SwiftUI
import SwiftData

struct iPadChapterSidebar: View {
  @Query var historyItems: [History]

  var chapters: [Chapter]
  @Binding var dataType: DataTypes
  @Binding var chapterId: String
  var refetch: () -> Void

  var body: some View {
    ScrollView {
      LazyVStack {
        Picker(selection: $dataType, label: Text("Data Type")) {
          Text("Data Saver").tag(DataTypes.dataSaver)
          Text("Data").tag(DataTypes.data)
        }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .padding(.top, 8)
            .onChange(of: dataType){
              refetch()
            }
        Picker(selection: $chapterId, label: Text("Chapter")) {
          ForEach(chapters, id: \.id) { chapter in
            Text(chapter.attributes.chapter ?? "N/A").tag(chapter.id.uuidString)
          }
        }
            .padding(.horizontal)
            .padding(.top, 8)
            .onChange(of: chapterId) {
              refetch()
            }
      }
    }
  }
}