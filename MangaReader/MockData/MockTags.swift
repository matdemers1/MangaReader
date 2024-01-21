//
//  MockTags.swift
//  MangaReader
//
//  Created by Matthew Demers on 1/21/24.
//

import Foundation

let MOCK_TAGS: [Tag] = [
  MOCK_MONSTER_TAG,
  MOCK_ACTION_TAG,
  MOCK_LONG_STRIP_TAG,
  MOCK_SURVIVAL_TAG,
  MOCK_ADVENTURE_TAG,
  MOCK_VIDEO_GAMES_TAG,
  MOCK_MAGIC_TAG,
  MOCK_ISEKAI_TAG,
  MOCK_GORE_TAG,
  MOCK_DRAMA_TAG,
  MOCK_FANTASY_TAG,
]
  
let MOCK_MONSTER_TAG: Tag = Tag(
  id: "36fd93ea-e8b8-445e-b836-358f02b3d33d",
  type: "tag",
  attributes: TagAttributes(
    name: ["en": "Monsters"],
    description: nil,
    group: "theme",
    version: 1
  ),
  relationships: []
)

let MOCK_ACTION_TAG: Tag = Tag(
  id: "391b0423-d847-456f-aff0-8b0cfc03066b",
  type: "tag",
  attributes: TagAttributes(
    name: ["en": "Action"],
    description: nil,
    group: "genre",
    version: 1
  ),
  relationships: []
)

let MOCK_LONG_STRIP_TAG: Tag = Tag(
  id: "3e2b8dae-350e-4ab8-a8ce-016e844b9f0d",
  type: "tag",
  attributes: TagAttributes(
    name: ["en": "Long Strip"],
    description: nil,
    group: "format",
    version: 1
  ),
  relationships: []
)

let MOCK_SURVIVAL_TAG: Tag = Tag(
  id: "5fff9cde-849c-4d78-aab0-0d52b2ee1d25",
  type: "tag",
  attributes: TagAttributes(
    name: ["en": "Survival"],
    description: nil,
    group: "theme",
    version: 1
  ),
  relationships: []
)

let MOCK_ADVENTURE_TAG: Tag = Tag(
  id: "87cc87cd-a395-47af-b27a-93258283bbc6",
  type: "tag",
  attributes: TagAttributes(
    name: ["en": "Adventure"],
    description: nil,
    group: "genre",
    version: 1
  ),
  relationships: []
)

let MOCK_VIDEO_GAMES_TAG: Tag = Tag(
  id: "9438db5a-7e2a-4ac0-b39e-e0d95a34b8a8",
  type: "tag",
  attributes: TagAttributes(
    name: ["en": "Video Games"],
    description: nil,
    group: "theme",
    version: 1
  ),
  relationships: []
)

let MOCK_MAGIC_TAG: Tag = Tag(
  id: "a1f53773-c69a-4ce5-8cab-fffcd90b1565",
  type: "tag",
  attributes: TagAttributes(
    name: ["en": "Magic"],
    description: nil,
    group: "theme",
    version: 1
  ),
  relationships: []
)

let MOCK_ISEKAI_TAG: Tag = Tag(
  id: "ace04997-f6bd-436e-b261-779182193d3d",
  type: "tag",
  attributes: TagAttributes(
    name: ["en": "Isekai"],
    description: nil,
    group: "genre",
    version: 1
  ),
  relationships: []
)

let MOCK_GORE_TAG: Tag = Tag(
  id: "b29d6a3d-1569-4e7a-8caf-7557bc92cd5d",
  type: "tag",
  attributes: TagAttributes(
    name: ["en": "Gore"],
    description: nil,
    group: "content",
    version: 1
  ),
  relationships: []
)

let MOCK_DRAMA_TAG: Tag = Tag(
  id: "b9af3a63-f058-46de-a9a0-e0c13906197a",
  type: "tag",
  attributes: TagAttributes(
    name: ["en": "Drama"],
    description: nil,
    group: "genre",
    version: 1
  ),
  relationships: []
)

let MOCK_FANTASY_TAG: Tag = Tag(
  id: "cdc58593-87dd-415e-bbc0-2ec27bf404cc",
  type: "tag",
  attributes: TagAttributes(
    name: ["en": "Fantasy"],
    description: nil,
    group: "genre",
    version: 1
  ),
  relationships: []
)

