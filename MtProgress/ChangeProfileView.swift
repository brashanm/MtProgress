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
            VStack {
                Text("Ready for a new look?")
                    .font(.system(size: 23, weight: .black))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                Text("Update your profile picture using a URL")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(.white)
                    .padding()
                
                TextField("URL", text: $photoURL)
                    .padding()
                    .background(textfieldColour.cornerRadius(15))
                    .frame(width: 360, height: 60)
                    .padding([.horizontal, .bottom])
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .keyboardType(.URL)
                
                AsyncImage(url: URL(string: photoURL)) { image in
                    image
                        .resizable()
                        .clipShape(Circle())
                        .scaledToFill()
                        .frame(width: 275, height: 275)
                        .onAppear {
                            validImage = true
                        }
                } placeholder: {
                    Image(.profile)
                        .resizable()
                        .foregroundStyle(middle)
                        .frame(width: 275, height: 275)
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
    }
}

#Preview {
    ChangeProfileView()
        .environmentObject(AuthenticationViewModel())
}
