//
//  AccountSettingsView.swift
//  MtProgress
//
//  Created by Brashan Mohanakumar on 2024-01-08.
//

import SwiftUI
import StoreKit

struct AccountSettingsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.requestReview) var requestReview
    @State private var requestedSignOut: Bool = false
    @State private var showAlert: Bool = false
    @State private var showReauthenticate: Bool = false
    
    var creationDate: String {
        var currentDate: Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        dateFormatter.timeZone = TimeZone.current
        if let creation = viewModel.user?.metadata.creationDate {
            currentDate = creation
        } else {
            currentDate = Date()
        }
        let formattedDate = dateFormatter.string(from: currentDate)
        return formattedDate
    }

    
    func signOut() {
        if viewModel.signOut() == false {
            showAlert = true
        } else {
            dismiss()
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    NavigationLink {
                        ChangeProfileView()
                            .environmentObject(viewModel)
                    } label: {
                        ZStack {
                            AsyncImage(url: viewModel.user?.photoURL) { image in
                                image
                                    .resizable()
                                    .clipShape(Circle())
                                    .scaledToFill()
                                    .frame(width: 150, height: 150)
                                    .overlay {
                                        Circle()
                                            .stroke(tertiaryColour, lineWidth: 8)
                                    }
                            } placeholder: {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .foregroundStyle(middle)
                                    .frame(width: 150, height: 150)
                                    .overlay {
                                        Circle()
                                            .stroke(tertiaryColour, lineWidth: 10)
                                    }
                            }
                            
                            Group {
                                Circle()
                                    .fill(tertiaryColour)
                                    .frame(width: 40, height: 40)
                                
                                Image(systemName: "pencil")
                                    .scaleEffect(1.4)
                                    .foregroundStyle(middle)
                            }
                            .offset(x: 50, y: 50)
                        }
                        .padding(.bottom, 10)
                    }
                    if let user = viewModel.user {
                        VStack {
                            Text(user.displayName ?? "")
                                .foregroundStyle(middle)
                                .font(.system(size: 26, weight: .heavy))
                            Text(user.email ?? "")
                                .buttonStyle(.plain)
                                .foregroundStyle(middle)
                                .font(.system(size: 20, weight: .semibold))
                                .padding(.horizontal)
                                .padding(.vertical, 2)
                        }
                    }
                }
                
                Text("Joined on \(creationDate)!")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(middle.opacity(0.6))
                    .padding(5)
                
                NavigationLink {
                    ChangeNameView()
                        .environmentObject(viewModel)
                } label: {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(tertiaryColour)
                        .overlay {
                            HStack {
                                Image(systemName: "square.and.pencil")
                                    .scaleEffect(1.9)
                                    .foregroundStyle(middle)
                                    .frame(width: 40, height: 40)
                                    .padding(.bottom, 6)
                                
                                Text("Change Name")
                                    .foregroundStyle(middle)
                                    .font(.system(size: 21, weight: .bold))
                                    .padding()
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .scaleEffect(1.2)
                                    .foregroundStyle(middle)
                                    .frame(width: 20, height: 20)
                                
                            }
                            .padding(.horizontal, 30)
                        }
                        .frame(height: 75)
                        .padding()
                }
                
                NavigationLink {
                    ChangePasswordView()
                        .environmentObject(viewModel)
                } label: {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(tertiaryColour)
                        .overlay {
                            HStack {
                                Image(systemName: "lock.fill")
                                    .scaleEffect(1.9)
                                    .foregroundStyle(middle)
                                    .frame(width: 40, height: 40)
                                
                                Text("Change Password")
                                    .foregroundStyle(middle)
                                    .font(.system(size: 21, weight: .bold))
                                    .padding()
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .scaleEffect(1.2)
                                    .foregroundStyle(middle)
                                    .frame(width: 20, height: 20)
                                
                            }
                            .padding(.horizontal, 30)
                        }
                        .frame(height: 75)
                        .padding()
                }
                
                Button {
                    requestedSignOut = true
                } label: {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(tertiaryColour)
                        .overlay {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .scaleEffect(1.6)
                                    .foregroundStyle(middle)
                                    .frame(width: 40, height: 40)
                                
                                Text("Sign Out")
                                    .foregroundStyle(middle)
                                    .font(.system(size: 21, weight: .bold))
                                    .padding()
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .scaleEffect(1.2)
                                    .foregroundStyle(middle)
                                    .frame(width: 20, height: 20)
                                
                            }
                            .padding(.horizontal, 30)
                        }
                        .frame(height: 75)
                        .padding()
                }
                
                NavigationLink {
                    DeleteView()
                        .environmentObject(viewModel)
                } label: {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(tertiaryColour)
                        .overlay {
                            HStack {
                                Image(systemName: "trash.fill")
                                    .scaleEffect(1.7)
                                    .foregroundStyle(.red)
                                    .frame(width: 40, height: 40)
                                
                                Text("Delete Account")
                                    .foregroundStyle(.red)
                                    .font(.system(size: 21, weight: .bold))
                                    .padding()
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .scaleEffect(1.2)
                                    .foregroundStyle(.red)
                                    .frame(width: 20, height: 20)
                            }
                            .padding(.horizontal, 30)
                        }
                        .frame(height: 75)
                        .padding()
                }
                
                Button {
                    requestReview()
                } label: {
                    Text("💛  Rate this app")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(middle)
                }
                .padding(.vertical, 10)
                .padding(.bottom, 20)
            }
            .padding(.top, 50)
            .alert("Are you sure you want to sign out", isPresented: $requestedSignOut) {
                Button("Sign Out", role: .destructive) {
                    signOut()
                }
                Button("Cancel", role: .cancel) {
                    print("Cancelled")
                }
            } message: {
                Text("You can log back in with your credentials at any time!")
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Something went wrong"), message: Text(viewModel.errorMessage), dismissButton: .cancel((Text("Cancel"))))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(primaryColour)
            .navigationBarBackButtonHidden()
            .onAppear {
                if viewModel.authenticationState == .unauthenticated {
                    dismiss()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(middle)
                            .scaleEffect(1.1)
                            .padding(.leading, 4)
                            .frame(width: 20)
                    }
                    .buttonStyle(.plain)
                }
                ToolbarItem(placement: .principal) {
                    Text("Account")
                        .font(.system(size: 25, weight: .heavy))
                        .foregroundStyle(middle)
                        .padding(.top, 5)
                }
            }
            .onAppear {
                if let window = UIApplication.shared.windows.first {
                    window.backgroundColor = UIColor(red: 58 / 255, green: 58 / 255, blue: 81 / 255, alpha: 1)
                }
            }
        }
    }
}

#Preview {
    AccountSettingsView()
        .environmentObject(AuthenticationViewModel())
}
