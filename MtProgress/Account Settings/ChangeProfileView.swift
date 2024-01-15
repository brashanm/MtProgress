//
//  ChangeProfileView.swift
//  MtProgress
//
//  Created by Brashan Mohanakumar on 2024-01-07.
//

import SwiftUI

struct ChangeProfileView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @State private var photoURL: String = ""
    @State private var wrongURL: Bool = false
    @State private var showAlert: Bool = false
    @State private var validImage: Bool = false
    @FocusState private var focused: Bool
    @State private var showText: Bool = false
    
    func changeProfilePicture() async {
        if let url = URL(string: photoURL) {
            if await viewModel.changeProfilePicture(url: url) == true {
                dismiss()
            } else {
                wrongURL = true
                showAlert = true
                withAnimation(Animation.spring(response: 0.2, dampingFraction: 0.2, blendDuration: 0.2)) {
                    wrongURL = false
                }
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack {
                    if !showText {
                        Text("Ready for a new look?")
                            .font(.title)
                            .fontWeight(.black)
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                        Text("Update your profile picture using a URL")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .padding()
                    } else {
                        Spacer(minLength: 50)
                    }
                    
                    TextField("URL", text: $photoURL)
                        .padding()
                        .background(textfieldColour.cornerRadius(15))
                        .frame(maxWidth: 500, maxHeight: 70)
                        .padding(.bottom)
                        .padding(.horizontal, 20)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .keyboardType(.URL)
                        .focused($focused)
                        .onAppear {
                            if let url = viewModel.user?.photoURL {
                                photoURL = url.absoluteString
                            }
                        }
                    
                    AsyncImage(url: URL(string: photoURL)) { image in
                        image
                            .resizable()
                            .clipShape(Circle())
                            .scaledToFill()
                            .frame(width: geometry.size.width / 1.5, height: geometry.size.width / 1.5)
                            .onAppear {
                                validImage = true
                            }
                    } placeholder: {
                        Image(.profile)
                            .resizable()
                            .foregroundStyle(middle)
                            .frame(width: geometry.size.width / 1.5, height: geometry.size.width / 1.5)
                            .onAppear {
                                validImage = false
                            }
                    }
                    .padding()
                    
                    Button {
                        Task {
                            await changeProfilePicture()
                        }
                    } label: {
                        Capsule()
                            .fill(secondaryColour)
                            .frame(width: 150, height: 75)
                            .overlay {
                                Text("Confirm")
                                    .foregroundStyle(middle)
                                    .font(.system(size: 24, weight: .heavy))
                            }
                    }
                    .buttonStyle(.plain)
                    .padding()
                    .disabled(!validImage)
                    .offset(x: wrongURL ? -5 : 0)
                }
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
            .onChange(of: focused, { oldValue, newValue in
                withAnimation {
                    showText = newValue
                }
            })
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
                    Text("Change Profile Picture")
                        .font(.system(size: 20, weight: .heavy))
                        .foregroundStyle(middle)
                        .padding(.top, 5)
                }
            }
            .alert(isPresented: $showAlert ) {
                Alert(title: Text("Invalid URL"), dismissButton: .cancel((Text("Cancel"))))
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    ChangeProfileView()
        .environmentObject(AuthenticationViewModel())
}
