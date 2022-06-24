//
//  AppCoordinator.swift
//
//
//  Created by Roberto Casula on 21/06/22.
//

import AuthClient
import ContactsClient
import ContactsFeature
import Foundation
import LoginFeature
import UIKit

public class AppCoordinator: NSObject, Coordinator {

    private let window: UIWindow
    public var rootViewController: UIViewController
    private var authClient: AuthClientProtocol
    private let contactsClient: ContactsClient

    public init(
        window: UIWindow,
        authClient: AuthClientProtocol,
        contactsClient: ContactsClient
    ) {
        self.window = window
        self.authClient = authClient
        self.contactsClient = contactsClient

        if let _ = authClient.getSavedCredentials() {
            let controller = ContactsController(
                authClient: authClient,
                contactsClient: contactsClient
            )
            self.rootViewController = UINavigationController(rootViewController: controller)
        } else {
            self.rootViewController = LoginController(authClient: authClient)
        }
    }

    public func start() {
        authClient.delegate = self
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}

extension AppCoordinator: AuthClientDelegate {

    public func didLogin() {
        let controller = UINavigationController(
            rootViewController: ContactsController(
                authClient: authClient,
                contactsClient: contactsClient
            )
        )
        window.swapRootViewController(with: controller, animationType: .dismiss)
    }

    public func didLogout() {
        let controller = LoginController(authClient: authClient)
        window.swapRootViewController(with: controller, animationType: .present)
    }
}
