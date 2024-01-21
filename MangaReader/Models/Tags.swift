//
// Created by Matthew Demers on 12/5/23.
//

import Foundation

struct TagResponse: Codable {
  var result: String
  var response: String
  var data: [Tag]
  var limit: Int
  var offset: Int
  var total: Int
}

struct Tag: Codable, Hashable {
  let id: String
  let type: String
  let attributes: TagAttributes
  let relationships: [Relationship]?
  
  init(id: String, type: String, attributes: TagAttributes, relationships: [Relationship]?) {
    self.id = id
    self.type = type
    self.attributes = attributes
    self.relationships = relationships
  }
}

struct TagAttributes: Codable, Hashable {
  let name: [String: String]
  let description: [String: String]?
  let group: String
  let version: Int
}
