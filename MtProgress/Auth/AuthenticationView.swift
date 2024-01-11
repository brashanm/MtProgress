//
//  AuthenticationView.swift
//  MtProgress
//
//  Created by Brashan Mohanakumar on 2024-01-05.
//

import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    var body: some View {
        if viewModel.flow == .signUp {
            SignUpView()
                .environmentObject(viewModel)
        }
        if viewModel.flow == .login {
            LoginView()
                .environmentObject(viewModel)
        }
    }
}

#Preview {
    AuthenticationView()
        .environmentObject(AuthenticationViewModel())
}
