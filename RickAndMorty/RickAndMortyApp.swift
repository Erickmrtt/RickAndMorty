//
//  RickAndMortyApp.swift
//  RickAndMorty
//
//  Created by erick on 19/06/24.
//

import SwiftUI

@main
struct RickAndMortyApp: App {
    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @StateObject var networkMonitor = NetworkMonitor()
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(networkMonitor)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
