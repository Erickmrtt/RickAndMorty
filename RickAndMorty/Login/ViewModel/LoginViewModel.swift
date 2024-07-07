//
//  LoginViewModel.swift
//  RickAndMorty
//
//  Created by erick on 24/06/24.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    @Published var userEmail = ""
    @Published var userPassword = ""
    @Published var formIsInvalid = false
    @Published var isLoginSuccess = false
    @Published var showErrorMessage = false
    @Dependency var authManager: AuthManager
    private var cancellables = Set<AnyCancellable>()
    init() {
        isFormViewInputsValid
            .receive(on: RunLoop.main)
            .assign(to: \.formIsInvalid, on: self)
            .store(in: &cancellables)
    }
    var isUserEmailValidPublisher: AnyPublisher<Bool, Never> {
        $userEmail
            .map { email in
                let emailPredicate = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
                return emailPredicate.evaluate(with: email)
            }
            .eraseToAnyPublisher()
    }

    var isPasswordValidPublisher: AnyPublisher<Bool, Never> {
        $userPassword
            .map { password in
                return password.count >= 8
            }
            .eraseToAnyPublisher()
    }

    var isFormViewInputsValid: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isUserEmailValidPublisher, isPasswordValidPublisher)
            .map { userEmailIsValid, passwordIsValid in
                return userEmailIsValid && passwordIsValid
            }
            .eraseToAnyPublisher()
    }
    @MainActor
    func loginValidation() async throws -> Bool {
        let login = try await authManager.login(email: userEmail, password: userPassword)
        isLoginSuccess = (login == .signedIn)
        showErrorMessage = (login != .signedIn)
        return isLoginSuccess
    }
}
