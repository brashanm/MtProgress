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
            VStack {
                Spacer()
                
                if !showText {
                    Text("Reauthentication Needed!")
                        .font(.system(size: 23, weight: .black))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                    Text("In order to delete your account, please verify your password")
                        .font(.system(size: 20, weight: .medium))
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
                    .frame(width: 360, height: 60)
                    .background(textfieldColour.cornerRadius(15))
                    .padding()
    
                    Button {
                        isShowingPassword.toggle()
                    } label: {
                        Image(systemName: isShowingPassword ? "eye.slash" : "eye")
                            .accentColor(primaryColour)
                            .opacity(0.8)
                            .scaleEffect(1.2)
                            .frame(width: 50, height: 50)
                    }
                    .offset(x: -20, y: 0)
                }
                
                Image(.rain)
                    .resizable()
                    .frame(width: 300, height: 300)
                    .padding(20)
                
                Spacer()
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
    }
}

//struct DeleteView: View {
//    @Environment(\.dismiss) var dismiss
//    @EnvironmentObject var viewModel: AuthenticationViewModel
//    @State private var isShowingPassword: Bool = false
//    @State private var wrongPassword: Bool = false
//    @State private var showPassword: Bool = false
//    @State private var showAlert: Bool = false
//    @State private var requestedDeleteAccount: Bool = false
//    
//    private var loginDisabled: Bool {
//        if viewModel.email.isEmpty || viewModel.password.isEmpty {
//            return true
//        } else {
//            return false
//        }
//    }
//    
//    func deleteAccount() async {
//        if await viewModel.deleteAccount() == false {
//            showAlert = true
//        } else {
//            dismiss()
//        }
//    }
//    
//    var body: some View {
//        VStack {
//            Text("Reauthentication Needed!")
//                .font(.system(size: 23, weight: .black))
//                .foregroundStyle(.white)
////                Text("Please enter your credentials first")
////                    .font(.system(size: 20, weight: .medium))
////                    .foregroundStyle(.white)
////                    .padding(1)
//            
////                TextField("Email", text: $viewModel.email)
////                    .padding()
////                    .background(textfieldColour.cornerRadius(15))
////                    .frame(width: 360, height: 60)
////                    .padding([.horizontal, .top])
////                    .autocorrectionDisabled()
////                    .autocapitalization(.none)
////                    .keyboardType(.emailAddress)
//            
//            ZStack(alignment: .trailing) {
//                Group {
//                    if !isShowingPassword {
//                        SecureField("Password", text: $viewModel.password)
//                    } else {
//                        TextField("Password", text: $viewModel.password)
//                            .autocorrectionDisabled()
//                            .autocapitalization(.none)
//                    }
//                }
//                .padding()
//                .frame(width: 360, height: 60)
//                .background(textfieldColour.cornerRadius(15))
//                .padding()
//                
//                Button {
//                    isShowingPassword.toggle()
//                } label: {
//                    Image(systemName: isShowingPassword ? "eye.slash" : "eye")
//                        .accentColor(primaryColour)
//                        .opacity(0.8)
//                        .scaleEffect(1.2)
//                        .frame(width: 50, height: 50)
//                }
//                .offset(x: -20, y: 0)
//            }
//            
//            Button {
//                Task {
//                    if await viewModel.signInWithEmailPassword() == true {
//                        withAnimation {
//                            viewModel.authenticate()
//                        }
//                    } else {
//                        wrongPassword = true
//                        showAlert = true
//                        withAnimation(Animation.spring(response: 0.2, dampingFraction: 0.2, blendDuration: 0.2)) {
//                            wrongPassword = false
//                        }
//                    }
//                }
//            } label: {
//                Capsule(style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
//                    .fill(secondaryColour)
//                    .frame(width: 333, height: 60)
//                    .padding()
//                    .overlay(
//                        Text("Reauthenticate")
//                            .font(.system(size: 24, weight: .heavy))
//                            .foregroundStyle(top)
//                        
//                    )
//                    .opacity(loginDisabled ? 0.4 : 1)
//                    .offset(x: wrongPassword ? -5 : 0)
//            }
//            .disabled(loginDisabled)
//        }
//        .alert("Are you sure you want to delete your account", isPresented: $requestedDeleteAccount) {
//            Button("Delete", role: .destructive) {
//                Task {
//                    await deleteAccount()
//                }
//            }
//            Button("Cancel", role: .cancel) {
//                print("Cancelled")
//            }
//        } message: {
//            Text("This action will permanently delete your account! This cannot be reversed!")
//        }
//        .alert(isPresented: $showAlert) {
//            Alert(title: Text("Error"), message: Text("\(viewModel.errorMessage)"), dismissButton: .cancel((Text("Cancel"))))
//        }
//        .ignoresSafeArea()
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(primaryColour)
//    }
//}

#Preview {
    DeleteView()
        .environmentObject(AuthenticationViewModel())
}
