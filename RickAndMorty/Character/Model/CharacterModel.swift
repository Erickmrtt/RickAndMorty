//
//  CharacterModel.swift
//  RickAndMorty
//
//  Created by erick on 19/06/24.
//

import Foundation

// MARK: - Character
struct CharacterModel: Codable {
    let results: [CharacterResult]?
}

// MARK: - Result
struct CharacterResult: Codable, Identifiable {
    let id: Int?
    let name: String?
    let status: Status?
    let species: Species?
    let type: String?
    let gender: Gender?
    let origin, location: Location?
    let image: String?
    let episode: [String]?
}

enum Gender: String, Codable {
    case female = "Female"
    case male = "Male"
    case unknown = "unknown"
}

// MARK: - Location
struct Location: Codable {
    let name: String?
    let url: String?
}

enum Species: String, Codable {
    case alien = "Alien"
    case human = "Human"
}

enum Status: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}
