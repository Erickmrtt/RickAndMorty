//
//  RegisterViewModel.swift
//  RickAndMorty
//
//  Created by erick on 24/06/24.
//

import Foundation
import FirebaseAuth

class RegisterViewModel {
    func register(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            // ...
        }
    }
}
