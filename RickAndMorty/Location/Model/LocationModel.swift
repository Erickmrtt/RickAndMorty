//
//  LocationModel.swift
//  RickAndMorty
//
//  Created by erick on 22/06/24.
//

import Foundation

struct LocationModel: Codable {
    let results: [LocationResult]?
}

struct LocationResult: Codable {
    let name: String?
    let type: String?
    let dimension: String?
    let residents: [String]?
}
