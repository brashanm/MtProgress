//
//  MtProgressApp.swift
//  MtProgress
//
//  Created by Brashan Mohanakumar on 2024-01-04.
//

import SwiftUI
import Combine
import Amplify
import AWSCognitoAuthPlugin
import AWSDataStorePlugin
import AWSAPIPlugin
import AWSS3StoragePlugin

@main
struct MtProgressApp: App {
    init() {
        configureAmplify()
        AppServiceManager.shared.configure()
    }
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

func configureAmplify() {
    
    #if DEBUG
    Amplify.Logging.logLevel = .verbose
    #endif

    do {
        try Amplify.add(plugin: AWSCognitoAuthPlugin())
        try Amplify.add(plugin: AWSDataStorePlugin(modelRegistration: AmplifyModels()))
        try Amplify.add(plugin: AWSAPIPlugin())
        try Amplify.add(plugin: AWSS3StoragePlugin())
        try Amplify.configure()
    } catch {
        Amplify.log.error(error: error)
    }
}
