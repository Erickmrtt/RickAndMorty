//
//  EpisodeModel.swift
//  RickAndMorty
//
//  Created by erick on 22/06/24.
//

import Foundation

struct EpisodeModel: Codable {
    let results: [EpisodeResult]?
}

struct EpisodeResult: Codable {
    let name: String?
    let airDate: String?
    let episode: String?
    let characters: [String]?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case airDate = "air_date"
        case episode = "episode"
        case characters = "characters"
    }
}
