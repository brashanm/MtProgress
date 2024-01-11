//
//  AuthenticationViewModel.swift
//  MtProgress
//
//  Created by Brashan Mohanakumar on 2024-01-04.
//

import Foundation
import FirebaseAuth
import Combine

enum AuthenticationState {
    case unauthenticated
    case authenticating
    case authenticated
    case loading
}

enum AuthenticationFlow {
    case login
    case signUp
}

@MainActor
class AuthenticationViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    @Published var flow: AuthenticationFlow = .signUp

    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var user: User?
    @Published var errorMessage: String = ""
    
    init() {
        authenticationState = .loading
        registerAuthStateHandler()
    }
    
    private var authStateHandle: AuthStateDidChangeListenerHandle?
    
    func registerAuthStateHandler() {
        if authStateHandle == nil {
            authStateHandle = Auth.auth().addStateDidChangeListener { auth, user in
                self.user = user
                self.authenticationState = user == nil ? .unauthenticated : .authenticated
            }
        }
    }

    func switchFlow() {
        flow = flow == .login ? .signUp : .login
        errorMessage = ""
    }
    
    private func wait() async {
        do {
            print("Wait")
            try await Task.sleep(nanoseconds: 1_000_000_000)
            print("Done")
        }
        catch {
            print(error)
        }
    }
    
    func reset() {
        flow = .signUp
        email = ""
        password = ""
        confirmPassword = ""
    }
    
    func authenticate() {
        authenticationState = .authenticated
    }
}



//Email and Password Authentication
extension AuthenticationViewModel {
    func signInWithEmailPassword() async -> Bool {
        authenticationState = .authenticating
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            user = authResult.user
            print("User \(authResult.user.uid) signed in")
            return true
        }
        catch {
            print(error)
            errorMessage = error.localizedDescription
            return false
        }
    }

    func signUpWithEmailPassword() async -> Bool {
        authenticationState = .authenticating
        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            user = authResult.user
            print("User \(authResult.user.uid) signed up")
            let changeRequest = user?.createProfileChangeRequest()
            changeRequest?.displayName = name
            do {
                try await changeRequest?.commitChanges()
                print("Success updating name to: \(user?.displayName ?? "NOTHING")")
            } catch {
                print("Error updating display name: \(error.localizedDescription)")
            }
            return true
        }
        catch {
            print(error)
            errorMessage = error.localizedDescription
            return false
        }
    }
    
    func changeName(name: String) async -> Bool {
        let changeRequest = user?.createProfileChangeRequest()
        changeRequest?.displayName = name
        do {
            try await changeRequest?.commitChanges()
            print("Success updating name to: \(String(describing: user?.displayName))")
            return true
        } catch {
            self.errorMessage = error.localizedDescription
            print("Error updating display name: \(error.localizedDescription)")
            return false
        }
    }
    
    func changePassword(password: String) async -> Bool {
        var success: Bool = false
        user?.updatePassword(to: password) { error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                print("Error updating password: \(error.localizedDescription)")
                success = false
            } else {
                print("Password updated successfully")
                success = true
            }
        }
        return success
    }
    
    func changeProfilePicture(url: URL) async -> Bool {
        let changeRequest = user?.createProfileChangeRequest()
        changeRequest?.photoURL = url
        do {
            try await changeRequest?.commitChanges()
            print("Success updating profile picture to \(String(describing: user?.photoURL))")
            return true
        } catch {
            self.errorMessage = error.localizedDescription
            print("Error updating display name: \(error.localizedDescription)")
            return false
        }
    }

    func signOut() -> Bool {
        do {
            try Auth.auth().signOut()
            authenticationState = .unauthenticated
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
        return true
    }

    func deleteAccount() async -> Bool {
        do {
            try await user?.delete()
            authenticationState = .unauthenticated
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
        return true
    }
}

