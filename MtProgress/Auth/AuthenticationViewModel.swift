//
//  AuthenticationViewModel.swift
//  MtProgress
//
//  Created by Brashan Mohanakumar on 2024-01-04.
//

import Foundation
import FirebaseAuth
import Combine
import UserNotifications

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
        name = ""
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
            notification()
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
                print("Success updating name to: \(user?.displayName ?? "")")
            } catch {
                print("Error updating display name: \(error.localizedDescription)")
            }
            notification()
            return true
        }
        catch {
            print(error)
            errorMessage = error.localizedDescription
            return false
        }
    }
    
    func notification() {
        let content = UNMutableNotificationContent()
        content.title = "Mount Progress"
        content.body = "You haven't posted your progress picture for today. Would you like to do it now?"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 86400, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
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
    
    func changePassword(oldPassword: String, password: String) async -> Bool {
        do {
            if let email = user?.email {
                let authenticated = await reauthenticate(email: email, password: oldPassword)
                if !authenticated {
                    return false
                }
            } else {
                self.errorMessage = "No Email"
                return false
            }
            
            let result: Bool = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Bool, Error>) in
                user?.updatePassword(to: password) { error in
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                        print("Error updating password: \(error.localizedDescription)")
                        continuation.resume(throwing: error)
                    } else {
                        print("Password updated successfully")
                        continuation.resume(returning: true)
                    }
                }
            }
            return result
        } catch {
            return false
        }
    }
    
    func reauthenticate(email: String, password: String) async -> Bool {
        let credential = FirebaseAuth.EmailAuthProvider.credential(withEmail: email, password: password)
        do {
            try await user?.reauthenticate(with: credential)
            return true
        } catch {
            self.errorMessage = error.localizedDescription
            return false
        }
    }
    
    func deleteAccount(password: String) async -> Bool {
        do {
            if let email = user?.email {
                let authenticated = await reauthenticate(email: email, password: password)
                if !authenticated {
                    return false
                }
            } else {
                self.errorMessage = "No Email"
                return false
            }
            
            try await user?.delete()
            authenticationState = .unauthenticated
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
        return true
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
}

