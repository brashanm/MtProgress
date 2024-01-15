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
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    
                    if !showText {
                        Text("Ready for a new name?")
                            .font(.title)
                            .fontWeight(.black)
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                        Text("Update your name below")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .padding(.top, 5)
                    } else {
                        Spacer()
                    }
                    
                    TextField("Name", text: $name)
                        .padding()
                        .background(textfieldColour.cornerRadius(15))
                        .frame(maxWidth: 500, maxHeight: 70)
                        .padding(.top)
                        .padding(.horizontal, 20)
                        .focused($focused)
                        .autocorrectionDisabled()
                        .autocapitalization(.words)
                        .onAppear {
                            name = viewModel.user?.displayName ?? ""
                        }
                    
                    
                    Image(.name)
                        .resizable()
                        .frame(width: geometry.size.width / 1.5, height: geometry.size.width / 1.5)
                        .padding()
                    
                    Spacer()
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
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    ChangeNameView()
        .environmentObject(AuthenticationViewModel())
}
