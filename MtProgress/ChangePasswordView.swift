//
//  ChangePasswordView.swift
//  MtProgress
//
//  Created by Brashan Mohanakumar on 2024-01-07.
//

import SwiftUI

struct ChangePasswordView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    @State private var oldPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var isShowingOld: Bool = false
    @State private var isShowingNew: Bool = false
    @State private var isShowingConfirm: Bool = false
    @State private var showAlert: Bool = false
    var valid: Bool {
        if confirmPassword == newPassword || !newPassword.isEmpty || !confirmPassword.isEmpty {
            return true
        } else {
            return false
        }
    }
    func changePassword() async {
        if await viewModel.changePassword(password: newPassword) == true {
            dismiss()
        } else {
            showAlert = true
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Want to change your password?")
                    .font(.system(size: 24, weight: .black))
                    .foregroundStyle(.white)
                    .frame(height: 58)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                Text("Your new password must be different from previous used passwords.")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .frame(height: 48)
                    .padding(.horizontal, 30)
                    .padding(.top, 15)

                ZStack(alignment: .trailing) {
                    Group {
                        if !isShowingNew {
                            SecureField("New Password", text: $newPassword)
                        } else {
                            TextField("New Password", text: $newPassword)
                                .autocorrectionDisabled()
                                .autocapitalization(.none)
                        }
                    }
                    .padding()
                    .frame(width: 360, height: 60)
                    .background(textfieldColour.cornerRadius(15))
                    .padding([.horizontal, .top])
                    
                    Button {
                        isShowingNew.toggle()
                    } label: {
                        Image(systemName: isShowingNew ? "eye.slash" : "eye")
                            .accentColor(primaryColour)
                            .opacity(0.8)
                            .scaleEffect(1.2)
                            .frame(width: 50, height: 50)
                    }
                    .offset(x: -20, y: 7)
                }
                .padding()
                ZStack(alignment: .trailing) {
                    Group {
                        if !isShowingConfirm {
                            SecureField("Password", text: $viewModel.password)
                        } else {
                            TextField("Password", text: $viewModel.password)
                                .autocorrectionDisabled()
                                .autocapitalization(.none)
                        }
                    }
                    .padding()
                    .frame(width: 360, height: 60)
                    .background(textfieldColour.cornerRadius(15))
                    .padding([.horizontal, .top])
                    
                    Button {
                        isShowingConfirm.toggle()
                    } label: {
                        Image(systemName: isShowingConfirm ? "eye.slash" : "eye")
                            .accentColor(primaryColour)
                            .opacity(0.8)
                            .scaleEffect(1.2)
                            .frame(width: 50, height: 50)
                    }
                    .offset(x: -20, y: 7)
                }
                Image(.security)
                    .resizable()
                    .frame(width: 285, height: 230)
                    .padding()
            }
            .alert(isPresented: $showAlert ) {
                Alert(title: Text("Error"), message: Text("\(viewModel.errorMessage)"), dismissButton: .cancel((Text("Cancel"))))
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
                    Text("Change Password")
                        .font(.system(size: 20, weight: .heavy))
                        .foregroundStyle(middle)
                        .padding(.top, 5)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task {
                            await changePassword()
                        }
                    } label: {
                        Text("Save")
                            .font(.system(size: 20, weight: .heavy))
                            .foregroundStyle(middle)
                            .padding(.top, 5)
                    }
                    .buttonStyle(.plain)
                    .disabled(valid)
                }
            }
        }
    }
}

#Preview {
    ChangePasswordView()
        .environmentObject(AuthenticationViewModel())
}
