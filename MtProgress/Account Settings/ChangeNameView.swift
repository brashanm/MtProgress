//
//  ChangeNameView.swift
//  MtProgress
//
//  Created by Brashan Mohanakumar on 2024-01-07.
//

import SwiftUI

struct ChangeNameView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @State private var name: String = ""
    @State private var showAlert: Bool = false
    @FocusState private var focused: Bool
    @State private var showText: Bool = false
    
    var valid: Bool {
        if name.isEmpty {
            return true
        } else {
            return false
        }

    }
    func changeName() async {
        if await viewModel.changeName(name: name) == true {
            dismiss()
        } else {
            showAlert = true
        }
    }
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                if !showText {
                    Text("Ready for a new name?")
                        .font(.system(size: 23, weight: .black))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                    Text("Update your name below")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.white)
                        .padding()
                } else {
                    Spacer()
                }
                
                TextField("Name", text: $name)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
                    .padding()
                    .frame(width: 360, height: 60)
                    .background(textfieldColour.cornerRadius(15))
                    .padding()
                    .focused($focused)
                    .onAppear {
                        name = viewModel.user?.displayName ?? ""
                    }
                Image(.name)
                    .resizable()
                    .frame(width: 250, height: 250)
                    .padding()
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
                    Text("Change Name")
                        .font(.system(size: 20, weight: .heavy))
                        .foregroundStyle(middle)
                        .padding(.top, 5)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task {
                            await changeName()
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
    ChangeNameView()
        .environmentObject(AuthenticationViewModel())
}
