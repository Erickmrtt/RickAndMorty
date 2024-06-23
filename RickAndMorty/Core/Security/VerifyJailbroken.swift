//
//  VerifyJailbroken.swift
//  RickAndMorty
//
//  Created by erick on 19/06/24.
//

import Foundation
import UIKit

class VerifyJailBroken {
    static func getJailbrokenStatus() -> Bool {
        if TARGET_IPHONE_SIMULATOR != 1 {
            if FileManager.default.fileExists(atPath: "/Applications/Cydia.app")
                || FileManager.default.fileExists(atPath: "/Library/MobileSubstrate/MobileSubstrate.dylib")
                || FileManager.default.fileExists(atPath: "/bin/bash")
                || FileManager.default.fileExists(atPath: "/usr/sbin/sshd")
                || FileManager.default.fileExists(atPath: "/etc/apt")
                || FileManager.default.fileExists(atPath: "/private/var/lib/apt/")
                || UIApplication.shared.canOpenURL(URL(string:"cydia://package/com.example.package")!) {
                return true
            }
            let stringToWrite = "Jailbreak Test"
            do {
                try stringToWrite.write(toFile:"/private/JailbreakTest.txt", atomically:true, encoding:String.Encoding.utf8)
                return true
            } catch {
                return false
            }
        }
        else {
            return false
        }
    }
    static func isJailBrokenFilesPresentInTheDirectory() -> Bool {
        let fm = FileManager.default
        if(fm.fileExists(atPath: "/private/var/lib/apt")) || (fm.fileExists(atPath: "/Applications/Cydia.app")){
            return true
        } else {
            return false
        }
    }
}
