//
//  LoginView.swift
//  MtProgress
//
//  Created by Brashan Mohanakumar on 2024-01-04.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @State private var isShowingPassword: Bool = false
    @State private var wrongPassword: Bool = false
    @State private var showPassword: Bool = false
    @State private var showAlert: Bool = false
    
    private var loginDisabled: Bool {
        if viewModel.email.isEmpty || viewModel.password.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    var body: some View {
        VStack {
            Text("Already a member?")
                .font(.system(size: 23, weight: .black))
                .foregroundStyle(.white)
            Text("Login to your account")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(.white)
                .padding(.top, 5)
            
            TextField("Email", text: $viewModel.email)
                .padding()
                .background(textfieldColour.cornerRadius(15))
                .frame(maxWidth: 500, maxHeight: 70)
                .padding(.top)
                .padding(.horizontal, 20)
                .autocorrectionDisabled()
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
            
            ZStack(alignment: .trailing) {
                Group {
                    if !isShowingPassword {
                        SecureField("Password", text: $viewModel.password)
                    } else {
                        TextField("Password", text: $viewModel.password)
                            .autocorrectionDisabled()
                            .autocapitalization(.none)
                    }
                }
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
            
            Button {
                Task {
                    if await viewModel.signInWithEmailPassword() == true {
                        withAnimation {
                            viewModel.authenticate()
                        }
                    } else {
                        wrongPassword = true
                        showAlert = true
                        withAnimation(Animation.spring(response: 0.2, dampingFraction: 0.2, blendDuration: 0.2)) {
                            wrongPassword = false
                        }
                    }
                }
            } label: {
                Capsule(style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                    .fill(secondaryColour)
                    .frame(width: 333, height: 60)
                    .padding()
                    .overlay(
                        Text("Log in")
                            .font(.system(size: 24, weight: .heavy))
                            .foregroundStyle(top)
                        
                    )
                    .opacity(loginDisabled ? 0.4 : 1)
                    .offset(x: wrongPassword ? -5 : 0)
            }
            .disabled(loginDisabled)
            
            HStack {
                Text("Don't have an account yet?")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.white)
                    .padding(2)
                Button {
                    withAnimation {
                        viewModel.switchFlow()
                    }
                } label: {
                    Text("Sign up")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(Color(red: 1, green: 0.803921568627451, blue: 0.8156862745098039))
                        .padding(2)
                }
                .buttonStyle(.plain)
                .onTapGesture {
                    viewModel.reset()
                    viewModel.switchFlow()
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text("\(viewModel.errorMessage)"), dismissButton: .cancel((Text("Cancel"))))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(primaryColour)
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthenticationViewModel())
}
