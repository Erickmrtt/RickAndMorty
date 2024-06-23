//
//  CharacterViewModel.swift
//  RickAndMorty
//
//  Created by erick on 22/06/24.
//

import Foundation

class CharacterViewModel: ObservableObject {
    @Dependency var characterRepository: CharacterRepository
    @Published var characters: CharacterModel?
    @Published var searchResults: [CharacterResult] = []

    func fetchCharacters() async {
        do {
            let characters = try await characterRepository.fetchCharacters()
            DispatchQueue.main.async {
                self.characters = characters
            }
        } catch {
            print("Error fetching characters: \(error)")
        }
    }
}


@MainActor class ContentViewModel: ObservableObject {
    @Published var characters: CharacterModel?
    @Dependency var characterRepository: CharacterRepository

    init() {
        loadCharacters()
    }
}
// MARK: - Async Await
extension ContentViewModel {
    func loadCharacters() {
        Task(priority: .medium) {
            try await characters = characterRepository.fetchAllCharacters()
        }
    }
}
