//
//  ContentView.swift
//  MtProgress
//
//  Created by Brashan Mohanakumar on 2024-01-04.
//

import SwiftUI

let primaryColour = Color(red: 66 / 255, green: 66 / 255, blue: 91 / 255)

let secondaryColour = Color(red: 26 / 255, green: 26 / 255, blue: 56 / 255)

let tertiaryColour = Color(red: 47 / 255, green: 46 / 255, blue: 73 / 255)

let textfieldColour = Color(red: 124 / 255, green: 124 / 255, blue: 147 / 255)

let top = Color(red: 1, green: 0.803921568627451, blue: 0.8156862745098039)

let middle = Color(red: 1, green: 0.8941176470588236, blue: 0.8509803921568627)

let bottom = Color(red: 0.6627450980392157, green: 0.6313725490196078, blue: 0.788235294117647)

let primaryFont = "AlfaSlabOne-Regular"

struct ContentView: View {
    @StateObject private var viewModel: AuthenticationViewModel = AuthenticationViewModel()
    var body: some View {
        NavigationStack {
            switch viewModel.authenticationState {
            case .loading:
                LoadingView()
            case .unauthenticated, .authenticating:
                StartingScreenView()
                    .environmentObject(viewModel)
                    .onAppear {
                        viewModel.reset()
                    }
            case .authenticated:
                HomeScreenView()
                    .environmentObject(viewModel)
            }
        }
        .animation(.smooth, value: viewModel.authenticationState)
    }
}

#Preview {
    ContentView()
}

