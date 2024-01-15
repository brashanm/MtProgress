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
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    
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
                                    .frame(width: geometry.size.width / 2.75, height: geometry.size.width / 2.75)
                                    .overlay {
                                        Circle()
                                            .stroke(tertiaryColour, lineWidth: 8)
                                    }
                            } placeholder: {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .foregroundStyle(middle)
                                    .frame(width: geometry.size.width / 2.75, height: geometry.size.width / 2.75)
                                    .overlay {
                                        Circle()
                                            .stroke(tertiaryColour, lineWidth: 10)
                                    }
                            }
                            
                            Group {
                                Circle()
                                    .fill(tertiaryColour)
                                    .frame(width: geometry.size.width / 12, height: geometry.size.width / 12)
                                
                                Image(systemName: "pencil")
                                    .scaleEffect(geometry.size.width / 350)
                                    .foregroundStyle(middle)
                            }
                            .offset(x: geometry.size.width / 7.5, y: geometry.size.width / 7.5)
                        }
                        .padding(.bottom, 10)
                    }
                    .padding(.top)
                    
                    if let user = viewModel.user {
                        Text(user.displayName ?? "")
                            .foregroundStyle(middle)
                            .font(.title)
                            .fontWeight(.heavy)
                            .padding(.bottom, 5)
                    }
                    
                    Text("Joined on \(creationDate)!")
                        .font(.title3)
                        .bold()
                        .foregroundStyle(middle.opacity(0.6))
                    
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
                                        .frame(width: geometry.size.width / 20, height: geometry.size.width / 20)
                                        .padding(.bottom, 6)
                                    
                                    Text("Change Name")
                                        .foregroundStyle(middle)
                                        .font(.title2)
                                        .bold()
                                        .padding()
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .scaleEffect(1.2)
                                        .foregroundStyle(middle)
                                        .frame(width: geometry.size.width / 20, height: geometry.size.width / 20)
                                    
                                }
                                .padding(.horizontal, 30)
                            }
                            .frame(height: geometry.size.height / 10)
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
                                        .frame(width: geometry.size.width / 20, height: geometry.size.width / 20)
                                    
                                    Text("Change Password")
                                        .foregroundStyle(middle)
                                        .font(.title2)
                                        .bold()
                                        .padding()
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .scaleEffect(1.2)
                                        .foregroundStyle(middle)
                                        .frame(width: geometry.size.width / 20, height: geometry.size.width / 20)
                                    
                                }
                                .padding(.horizontal, 30)
                            }
                            .frame(height: geometry.size.height / 10)
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
                                        .frame(width: geometry.size.width / 20, height: geometry.size.width / 20)
                                    
                                    Text("Sign Out")
                                        .foregroundStyle(middle)
                                        .font(.title2)
                                        .bold()
                                        .padding()
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .scaleEffect(1.2)
                                        .foregroundStyle(middle)
                                        .frame(width: geometry.size.width / 20, height: geometry.size.width / 20)
                                    
                                }
                                .padding(.horizontal, 30)
                            }
                            .frame(height: geometry.size.height / 10)
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
                                        .frame(width: geometry.size.width / 20, height: geometry.size.width / 20)
                                    
                                    Text("Delete Account")
                                        .foregroundStyle(.red)
                                        .font(.title2)
                                        .bold()
                                        .padding()
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .scaleEffect(1.2)
                                        .foregroundStyle(.red)
                                        .frame(width: geometry.size.width / 20, height: geometry.size.width / 20)
                                }
                                .padding(.horizontal, 30)
                            }
                            .frame(height: geometry.size.height / 10)
                            .padding()
                    }
                    
                    Button {
                        requestReview()
                    } label: {
                        Text("💛  Rate this app")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundStyle(middle)
                    }
                    
                    Spacer()
                }
                .padding(.vertical, geometry.size.height / 30)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
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
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    AccountSettingsView()
        .environmentObject(AuthenticationViewModel())
}
