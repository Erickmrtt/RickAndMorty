//
//  AuthManager.swift
//  RickAndMorty
//
//  Created by erick on 25/06/24.
//

import AuthenticationServices
import FirebaseAuth
import FirebaseCore

class AuthManager: ObservableObject {
    @Published var user: User?
    @Published var authState = AuthState.signedOut
    @Published var userSession: FirebaseAuth.User?
    private var authStateHandle: AuthStateDidChangeListenerHandle!
    @Published var signedIn:Bool = false
    init() {
        // 3.
        configureAuthStateChanges()
    }

    // 2.
    func configureAuthStateChanges() {
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            if user != nil {
                self?.signedIn = true
                print("Auth state changed, is signed in \(String(describing: self?.authState))")
            } else {
                self?.signedIn = false
                print("Auth state changed, is signed out\(String(describing: self?.authState)))")
            }
            self?.updateState(user: user)
        }
    }

    // 2.
    func removeAuthStateListener() {
        Auth.auth().removeStateDidChangeListener(authStateHandle)
    }

    // 4.
    func updateState(user: User?) {
        self.user = user
        let isAuthenticatedUser = user != nil
        let isAnonymous = user?.isAnonymous ?? false

        if isAuthenticatedUser {
            self.authState = isAnonymous ? .authenticated : .signedIn
        } else {
            self.authState = .signedOut
        }
    }

    func login(email: String?, password: String?) async throws -> AuthState{
        guard let email = email, let password = password else {
            return .signedOut
        }
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            return .signedIn
        } catch {
            return .signedOut
        }
    }

    func signUp(email: String, password: String) async throws {
        do {
            let v = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = v.user
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }

    func signOut() async throws {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
        } catch {
            throw error
        }
    }

    func deleteAccount() async throws {
        do {
            try await Auth.auth().currentUser?.delete()
        } catch {
            throw error
        }
    }

    func resetPassword(email: String) async throws {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch {
            throw error
        }
    }

    func loginWithEmailCode(email: String ,verificationCode: String) async throws {
        do {
            try await Auth.auth().signIn(withEmail: email, link: verificationCode)
        } catch {
            throw error
        }
    }
}
