//
// Created by Matthew Demers on 12/15/23.
//

import Foundation
import SwiftData

enum MangaReaderMigrationPlan: SchemaMigrationPlan{
  static var schemas: [VersionedSchema.Type]{
    [SchemaV1.self, SchemaV2.self]
  }

  static var stages: [MigrationStage]{
    []
  }
}