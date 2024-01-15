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
            GeometryReader { geometry in
                VStack {
                    if !showText {
                        Text("Your new password must be different from previous used passwords.")
                            .font(.title3)
                            .bold()
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
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
                        .background(textfieldColour.cornerRadius(15))
                        .frame(maxWidth: 500, maxHeight: 70)
                        .padding(.top)
                        .padding(.horizontal, 20)
                        
                        Button {
                            isShowingOld.toggle()
                        } label: {
                            Image(systemName: isShowingOld ? "eye.slash" : "eye")
                                .accentColor(primaryColour)
                                .opacity(0.8)
                                .scaleEffect(1.2)
                                .frame(width: 50, height: 50)
                        }
                        .padding(.top)
                        .padding(.horizontal, 20)
                    }
                    
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
                        .background(textfieldColour.cornerRadius(15))
                        .frame(maxWidth: 500, maxHeight: 70)
                        .padding(.top, 10)
                        .padding(.horizontal, 20)
                        
                        Button {
                            isShowingNew.toggle()
                        } label: {
                            Image(systemName: isShowingNew ? "eye.slash" : "eye")
                                .accentColor(primaryColour)
                                .opacity(0.8)
                                .scaleEffect(1.2)
                                .frame(width: 50, height: 50)
                        }
                        .padding(.top)
                        .padding(.horizontal, 20)
                    }
                    
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
                        .background(textfieldColour.cornerRadius(15))
                        .frame(maxWidth: 500, maxHeight: 70)
                        .padding(.top)
                        .padding(.horizontal, 20)
                        
                        Button {
                            isShowingConfirm.toggle()
                        } label: {
                            Image(systemName: isShowingConfirm ? "eye.slash" : "eye")
                                .accentColor(primaryColour)
                                .opacity(0.8)
                                .scaleEffect(1.2)
                                .frame(width: 50, height: 50)
                        }
                        .padding(.top)
                        .padding(.horizontal, 20)
                    }
            
                    Image(.security)
                        .resizable()
                        .frame(width: geometry.size.width / 1.25, height: geometry.size.width / 1.5)
                        .padding(20)
                }
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
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
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    ChangePasswordView()
        .environmentObject(AuthenticationViewModel())
}
