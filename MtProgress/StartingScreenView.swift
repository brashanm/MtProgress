//
//  StartingScreenView.swift
//  MtProgress
//
//  Created by Brashan Mohanakumar on 2024-01-04.
//

import SwiftUI
import UserNotifications

struct StartingScreenView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @State private var startAuthorization = false
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if !startAuthorization {
                    Text("Mt. Progress")
                        .font(.custom(primaryFont, size: 44))
                        .foregroundStyle(primaryColour)
                        .offset(y: -222)
                } else {
                    AuthenticationView()
                        .environmentObject(viewModel)
                        .transition(.move(edge: .bottom))
                }
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
            .background(
                Image(.mountains2)
                    .resizable()
                    .scaledToFill()
                    .clipped()
            )
            .ignoresSafeArea()
            .onTapGesture {
                withAnimation {
                    startAuthorization = true
                }
            }
            .onAppear {
                requestNotificationPermission()
            }
        }
    }
}

#Preview {
    StartingScreenView()
        .environmentObject(AuthenticationViewModel())
}
