//
//  StartScreenView.swift
//  MtProgress
//
//  Created by Brashan Mohanakumar on 2024-01-05.
//

import SwiftUI

struct StartScreenView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    @State private var signUp: Bool = false
    @State private var login: Bool = false
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.authenticationState != .authenticated {
                    Text("Mt. Progress")
                        .font(.custom(primaryFont, size: 44))
                        .foregroundStyle(primaryColour)
                        .offset(y: -222)
                } else {
                    HomeScreenView()
                        .environmentObject(viewModel)
                        .transition(.slide)
                }
            }
            .ignoresSafeArea()
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
            .background(
                Image(.mountains)
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()
            )
            .onTapGesture {
                withAnimation {
                    signUp = true
                }
            }
            .sheet(isPresented: $signUp) {
                SignUpView(login: $login, signUp: $signUp)
                    .environmentObject(viewModel)
                    .onAppear {
                        if let window = UIApplication.shared.windows.first {
                            window.backgroundColor = UIColor(Color(red: 224 / 255, green: 173 / 255, blue: 176 / 255))
                        }
                    }
            }
            .sheet(isPresented: $login) {
                LoginView(login: $login, signUp: $signUp)
                    .environmentObject(viewModel)
                    .onAppear {
                        if let window = UIApplication.shared.windows.first {
                            window.backgroundColor = UIColor(Color(red: 224 / 255, green: 173 / 255, blue: 176 / 255))
                        }
                    }
            }
        }
    }
}


#Preview {
    StartScreenView()
        .environmentObject(AuthenticationViewModel())
}
