//
//  AppDelegate.swift
//  RickAndMorty
//
//  Created by erick on 19/06/24.
//

import Foundation
import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        DependencyContainerRegister.registerDependencies()
        return true
    }


}
