//
//  NavigationStateManager.swift
//  RickAndMorty
//
//  Created by erick on 23/06/24.
//

import Foundation
import Combine

class NavigationStateManager<T: Hashable & Codable>: ObservableObject {

    @Published var selectionPath = [T]()

    var data: Data? {
        get {
           try? JSONEncoder().encode(selectionPath)
        }
        set {

            guard let data = newValue,
                  let path = try? JSONDecoder().decode([T].self, from: data) else {
                return
            }

            self.selectionPath = path
        }
    }

    func popToRoot() {
        selectionPath = []
    }

    func goToState(_ state: T) {
        selectionPath = [state]
    }

    func clearAndGoToState(_ state: T) {
            selectionPath = []
            selectionPath.append(state)
        }

    var objectWillChangeSequence: AsyncPublisher<Publishers.Buffer<ObservableObjectPublisher>> {
        objectWillChange
            .buffer(size: 1, prefetch: .byRequest, whenFull: .dropOldest)
            .values
    }
}
