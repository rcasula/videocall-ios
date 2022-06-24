//
//  AppDelegate.swift
//  LoginPreview
//
//  Created by Roberto Casula on 20/06/22.
//

import UIKit
import AuthClient
import ApiClient
import LoginFeature
import PersistenceClient
import KeychainClientLive

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let authClient = AuthClient(
            apiClient: MockApiClient(enabledUsers: ["jshier": "test"], enableDelay: true),
            keychainClient: KeychainClientLive(),
            persistenceClient: PersistenceClient()
        )
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = LoginController(authClient: authClient)
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}

