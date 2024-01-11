//
//  StartingScreenView.swift
//  MtProgress
//
//  Created by Brashan Mohanakumar on 2024-01-04.
//

import SwiftUI

struct StartingScreenView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @State private var startAuthorization = false
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
            .ignoresSafeArea()
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
            .background(MountainsBackground())
            .onTapGesture {
                withAnimation {
                    startAuthorization = true
                }
            }
        }
    }
}

#Preview {
    StartingScreenView()
        .environmentObject(AuthenticationViewModel())
}
