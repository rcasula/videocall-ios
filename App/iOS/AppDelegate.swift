//
//  AppDelegate.swift
//  videocall
//
//  Created by Roberto Casula on 14/06/22.
//

import UIKit
import AuthClient
import ApiClient
import KeychainClientLive
import ContactsClient
import PersistenceClient
import AppFeature

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: AppCoordinator?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let authClient = AuthClient(
            apiClient: MockApiClient(
                enabledUsers: [
                    "jshier": "123456"
                ],
                enableDelay: true
            ),
            keychainClient: KeychainClientLive(),
            persistenceClient: PersistenceClient(),
            rememberCredentials: true
        )
        let contactsClient = MockContactsClient()
        let window = UIWindow(frame: UIScreen.main.bounds)
        let coordinator = AppCoordinator(
            window: window,
            authClient: authClient,
            contactsClient: contactsClient
        )
        self.coordinator = coordinator
        self.window = window

        coordinator.start()
        return true
    }

}
