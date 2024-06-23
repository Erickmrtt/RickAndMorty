//
//  DependencyContainerRegister.swift
//  RickAndMorty
//
//  Created by erick on 19/06/24.
//

import Foundation

class DependencyContainerRegister {
    static func registerDependencies() {
        DependencyContainer.register(NetworkManager())
        DependencyContainer.register(CharacterRepository())
    }
}
