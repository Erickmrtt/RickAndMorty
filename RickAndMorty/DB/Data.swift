//
//  Data.swift
//  RickAndMorty
//
//  Created by erick on 21/06/24.
//

import Foundation
import CoreData

class DBController: ObservableObject {
    let container = NSPersistentContainer(name: "RickAndMorty")
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error loading Core Data. \(error)")
            }
        }
    }
}
