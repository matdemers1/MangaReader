//
//  MockMangaObject.swift
//  MangaReader
//
//  Created by Matthew Demers on 1/20/24.
//

import Foundation

let MOCK_MANGA_OBJECT: Manga = {
  return Manga(
    id: "18f42811-ce55-4143-ae30-b97e30e6cf82",
    type: "manga",
    attributes: MOCK_MANGA_ATTRIBUTES,
    relationships: []
  );
}()


let MOCK_MANGA_ATTRIBUTES: MangaAttributes = {
  return MangaAttributes(
    title: Title( title: "I Became the Tyrant of a Defense Game"),
    altTitles: nil,
    description: Description( description:
      "Protect the Empire was considered unbeatable for over a decade until streamer extraordinaire Mr. Gamer Geek comes along and defeats the game on its hardest mode. But just when he's about to rest on his laurels, he's sucked into the world of the game by some mysterious figure and thrust into Prince Ash's body!\n\nAsh now realizes that every click and command he had mindlessly sent out had real, gruesome costs - including his teammates' lives that he sacrificed for the sake of victory. To make up for his previous actions, Ash promises to keep his whole team alive this time while using his wits and knowledge to survive the hellish onslaught of monsters. \n\nBut who brought him to this world in the first place, and why?\n\nAsh may soon find the answers to these questions - if he can survive the bloody battlefield first!"
    ),
    isLocked: false,
    links: nil,
    originalLanguage: "ko",
    lastVolume: nil,
    lastChapter: nil,
    publicationDemographic: PublicationDemographic.seinen.description,
    status: Status.ongoing.description,
    year: 2023,
    contentRating: ContentRating.safe.description,
    tags: MOCK_TAGS,
    state: nil,
    chapterNumbersResetOnNewVolume: nil,
    createdAt: nil,
    updatedAt: nil,
    version: nil,
    availableTranslatedLanguages: ["en"],
    latestUploadedChapter: nil
  );
}()


