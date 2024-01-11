//
//  SignUpView.swift
//  MountProgress
//
//  Created by Brashan Mohanakumar on 2023-12-27.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @State private var isShowingPassword: Bool = false
    @State private var isShowingConfirmed: Bool = false
    @State private var wrongPassword: Bool = false
    @State private var showAlert: Bool = false
    
    private var signupDisabled: Bool {
        if viewModel.name.isEmpty || viewModel.email.isEmpty || viewModel.password.isEmpty || viewModel.confirmPassword.isEmpty || viewModel.password != viewModel.confirmPassword {
            return true
        } else {
            return false
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Ready to get started?")
                    .font(.system(size: 23, weight: .black))
                    .foregroundStyle(.white)
                Text("Create your account")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(.white)
                    .padding(1)
                
                TextField("Name", text: $viewModel.name)
                    .padding()
                    .background(textfieldColour.cornerRadius(15))
                    .frame(width: 360, height: 60)
                    .padding([.horizontal, .top])
                
                TextField("Email", text: $viewModel.email)
                    .padding()
                    .background(textfieldColour.cornerRadius(15))
                    .frame(width: 360, height: 60)
                    .padding([.horizontal, .top])
                    .autocorrectionDisabled()
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                
                ZStack(alignment: .trailing) {
                    Group {
                        if !isShowingPassword {
                            SecureField("Password over 6 characters", text: $viewModel.password)
                        } else {
                            TextField("Password over 6 characters", text: $viewModel.password)
                                .autocorrectionDisabled()
                                .autocapitalization(.none)
                        }
                    }
                    .padding()
                    .frame(width: 360, height: 60)
                    .background(textfieldColour.cornerRadius(15))
                    .padding([.horizontal, .top])
                    
                    Button {
                        isShowingPassword.toggle()
                    } label: {
                        Image(systemName: isShowingPassword ? "eye.slash" : "eye")
                            .accentColor(primaryColour)
                            .opacity(0.8)
                            .scaleEffect(1.2)
                            .frame(width: 50, height: 50)
                    }
                    .offset(x: -20, y: 7)
                }
                
                ZStack(alignment: .trailing) {
                    Group {
                        if !isShowingConfirmed {
                            SecureField("Confirm Password", text: $viewModel.confirmPassword)
                        } else {
                            TextField("Confirm Password", text: $viewModel.confirmPassword)
                                .autocorrectionDisabled()
                                .autocapitalization(.none)
                        }
                    }
                    .padding()
                    .frame(width: 360, height: 60)
                    .background(textfieldColour.cornerRadius(15))
                    .padding([.horizontal, .top])
                    
                    Button {
                        isShowingConfirmed.toggle()
                    } label: {
                        Image(systemName: isShowingConfirmed ? "eye.slash" : "eye")
                            .accentColor(primaryColour)
                            .opacity(0.8)
                            .scaleEffect(1.2)
                            .frame(width: 50, height: 50)
                    }
                    .offset(x: -20, y: 7)
                }
                
                Button {
                    Task {
                        if await viewModel.signUpWithEmailPassword() == true {
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
                    Capsule(style: .continuous)
                        .fill(secondaryColour)
                        .frame(width: 333, height: 60)
                        .padding()
                        .overlay(
                            Text("Sign up")
                                .font(.system(size: 24, weight: .heavy))
                                .foregroundStyle(top)
                            
                        )
                        .opacity(signupDisabled ? 0.4 : 1)
                        .offset(x: wrongPassword ? -5 : 0)
                }
                .disabled(signupDisabled)
                
                HStack {
                    Text("Already have an account?")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(.white)
                        .padding(2)
                    Button {
                        withAnimation {
                            viewModel.switchFlow()
                        }
                    } label: {
                        Text("Sign in")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(Color(red: 1, green: 0.803921568627451, blue: 0.8156862745098039))
                            .padding(2)
                    }
                    .buttonStyle(.plain)
                }
            }
            .alert(isPresented: $showAlert ) {
                Alert(title: Text("Error"), message: Text("\(viewModel.errorMessage)"), dismissButton: .cancel((Text("Cancel"))))
            }
            .ignoresSafeArea()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(primaryColour)
        }
        .toolbar(.hidden)
    }
}

struct RumbleAnimationModifier: ViewModifier {
    @State private var shouldRumble = false
    func body(content: Content) -> some View {
        content
            .offset(x: shouldRumble ? -5 : 0)
            .onTapGesture {
                shouldRumble = true
                withAnimation(Animation.spring(response: 0.2, dampingFraction: 0.2, blendDuration: 0.2)) {
                    shouldRumble = false
                }
            }
    }
}

extension View {
    func rumbleAnimation() -> some View {
        self.modifier(RumbleAnimationModifier())
    }
}


#Preview {
    SignUpView()
        .environmentObject(AuthenticationViewModel())
}
