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
    @FocusState private var focusedField: FocusedField?
    @State private var showText: Bool = false
    
    var valid: Bool {
        if confirmPassword == newPassword && !newPassword.isEmpty && !confirmPassword.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    func changePassword() async {
        let changed = await viewModel.changePassword(oldPassword: oldPassword, password: newPassword)
        if changed == true {
            dismiss()
        } else {
            showAlert = true
        }
    }
    
    enum FocusedField {
        case old, password, confirmed
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if !showText {
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
                }
                
                ZStack(alignment: .trailing) {
                    Group {
                        if !isShowingOld {
                            SecureField("Old Password", text: $oldPassword)
                        } else {
                            TextField("Old Password", text: $oldPassword)
                                .autocorrectionDisabled()
                                .autocapitalization(.none)
                        }
                    }
                    .focused($focusedField, equals: .old)
                    .padding()
                    .frame(width: 360, height: 60)
                    .background(textfieldColour.cornerRadius(15))
                    .padding([.horizontal, .top])
                    
                    Button {
                        isShowingOld.toggle()
                    } label: {
                        Image(systemName: isShowingOld ? "eye.slash" : "eye")
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
                        if !isShowingNew {
                            SecureField("New Password", text: $newPassword)
                        } else {
                            TextField("New Password", text: $newPassword)
                                .autocorrectionDisabled()
                                .autocapitalization(.none)
                        }
                    }
                    .focused($focusedField, equals: .password)
                    .padding()
                    .frame(width: 360, height: 60)
                    .background(textfieldColour.cornerRadius(15))
                    .padding(.horizontal)
                    
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
                            SecureField("Confirm Password", text: $confirmPassword)
                        } else {
                            TextField("Confirm Password", text: $confirmPassword)
                                .autocorrectionDisabled()
                                .autocapitalization(.none)
                        }
                    }
                    .focused($focusedField, equals: .confirmed)
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
                    .padding(.top, 20)
            }
            .padding(.top, showText ? 120 : 0)
            .onChange(of: focusedField, { oldValue, newValue in
                if focusedField == nil {
                    withAnimation {
                        showText = false
                    }
                } else {
                    withAnimation {
                        showText = true
                    }
                }
            })
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
