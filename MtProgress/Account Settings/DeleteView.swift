//
//  ReauthenticateView.swift
//  MtProgress
//
//  Created by Brashan Mohanakumar on 2024-01-14.
//

import SwiftUI

struct DeleteView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @State private var isShowingPassword: Bool = false
    @State private var wrongPassword: Bool = false
    @State private var password: String = ""
    @State private var showPassword: Bool = false
    @State private var showAlert: Bool = false
    @State private var requestedDeleteAccount: Bool = false
    @State private var showText: Bool = false
    @FocusState private var focused: Bool
    
    func deleteAccount() async {
        if await viewModel.deleteAccount(password: password) == false {
            showAlert = true
        } else {
            dismiss()
        }
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack {
                    
                    if !showText {
                        Text("Reauthentication Needed!")
                            .font(.title)
                            .fontWeight(.heavy)
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                        Text("In order to delete your account, please verify your password")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                            .padding()
                    } else {
                        Spacer()
                    }
                    
                    ZStack(alignment: .trailing) {
                        Group {
                            if !isShowingPassword {
                                SecureField("Password", text: $password)
                            } else {
                                TextField("Password", text: $password)
                                    .autocorrectionDisabled()
                                    .autocapitalization(.none)
                            }
                        }
                        .focused($focused)
                        .padding()
                        .background(textfieldColour.cornerRadius(15))
                        .frame(maxWidth: 500, maxHeight: 70)
                        .padding(.top)
                        .padding(.horizontal, 20)
                        
                        Button {
                            isShowingPassword.toggle()
                        } label: {
                            Image(systemName: isShowingPassword ? "eye.slash" : "eye")
                                .accentColor(primaryColour)
                                .opacity(0.8)
                                .scaleEffect(1.2)
                                .frame(width: 50, height: 50)
                        }
                        .padding(.top)
                        .padding(.horizontal, 20)
                    }
                    
                    Image(.rain)
                        .resizable()
                        .frame(width: geometry.size.width / 1.5, height: geometry.size.width / 1.5)
                        .padding(20)
                }
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
            .onChange(of: focused, { oldValue, newValue in
                withAnimation {
                    showText = newValue
                }
            })
            .alert(isPresented: $showAlert ) {
                Alert(title: Text("Error"), message: Text("\(viewModel.errorMessage)"), dismissButton: .cancel((Text("Cancel"))))
            }
            .alert("Are you sure you want to delete your account", isPresented: $requestedDeleteAccount) {
                Button("Delete", role: .destructive) {
                    Task {
                        await deleteAccount()
                    }
                }
                Button("Cancel", role: .cancel) {
                    print("Cancelled")
                }
            } message: {
                Text("This action will permanently delete your account! This cannot be reversed!")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(primaryColour)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(middle)
                            .scaleEffect(1.2)
                            .padding(.leading, 4)
                            .frame(width: 20)
                    }
                    .buttonStyle(.plain)
                }
                ToolbarItem(placement: .principal) {
                    Text("Delete Account")
                        .font(.system(size: 20, weight: .heavy))
                        .foregroundStyle(middle)
                        .padding(.top, 5)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        requestedDeleteAccount = true
                    } label: {
                        Text("Delete")
                            .font(.system(size: 20, weight: .heavy))
                            .foregroundStyle(.red)
                            .padding(.top, 5)
                    }
                    .buttonStyle(.plain)
                    .disabled(password.isEmpty)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    DeleteView()
        .environmentObject(AuthenticationViewModel())
}
