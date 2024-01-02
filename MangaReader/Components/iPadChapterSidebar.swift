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
  @Binding var viewType: ViewType
  var refetch: () -> Void

  var body: some View {
    LazyVStack {
      Text("Image Quality")
          .font(.subheadline)
          .frame(maxWidth: .infinity, alignment: .leading)
      Picker(selection: $dataType, label: Text("Data Type")) {
        Text("Data Saver").tag(DataTypes.dataSaver)
        Text("Data").tag(DataTypes.data)
      }
          .pickerStyle(SegmentedPickerStyle())
          .padding(.bottom, 8)
          .onChange(of: dataType) {
            refetch()
          }
      Text("View Type")
          .font(.subheadline)
          .frame(maxWidth: .infinity, alignment: .leading)
      Picker(selection: $viewType, label: Text("View Type")) {
        Text("Single Page").tag(ViewType.singlePage)
        Text("Long Strip").tag(ViewType.longStrip)
      }
          .pickerStyle(SegmentedPickerStyle())
          .padding(.bottom, 8)

      HStack {
        Text("Chapters:")
            .font(.subheadline)
            .frame(maxWidth: .infinity, alignment: .leading)
        Spacer()
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
      Spacer()
    }
        .padding()
        .frame(maxHeight: .infinity, alignment: .top)
  }
}