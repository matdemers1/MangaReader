//
// Created by Matthew Demers on 12/15/23.
//

import Foundation
import SwiftData

enum MangaReaderMigrationPlan: SchemaMigrationPlan{
  static var schemas: [VersionedSchema.Type]{
    [SchemaV1.self, SchemaV2.self, SchemaV3.self]
  }

  static var stages: [MigrationStage]{
    [migrateV2toV3]
  }

  static let migrateV2toV3 = MigrationStage.custom(
      fromVersion: SchemaV2.self,
      toVersion: SchemaV3.self,
      willMigrate: nil,
      didMigrate: { context in
        let history = try context.fetch(FetchDescriptor<SchemaV3.History>())
        // add empty cover art url
        for item in history {
          item.coverArtURL = ""
        }
        try! context.save()
      }
  )
}