//
//  String+Extension.swift
//  RickAndMorty
//
//  Created by erick on 23/06/24.
//

import Foundation

public extension String {
    func localized() -> String {
        let path = Bundle.main.path(forResource: "en", ofType: "lproj")
        let bundle = Bundle(path: path!)
        return (bundle?.localizedString(forKey: self, value: nil, table: nil))!
    }
}
