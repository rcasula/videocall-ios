//
//  AppCoordinator.swift
//  
//
//  Created by Roberto Casula on 21/06/22.
//

import UIKit
import Foundation
import AuthClient
import LoginFeature
import ContactsClient
import ContactsFeature
import SharedModels
import ConversationFeature

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
        self.rootViewController = .init()
        super.init()
        if let _ = authClient.getSavedCredentials() {
            self.rootViewController = getContactsController()
        } else {
            self.rootViewController = LoginController(authClient: authClient)
        }
    }


    public func start() {
        authClient.delegate = self
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }

    private func getContactsController() -> UIViewController {
        let controller = ContactsController(
            authClient: authClient,
            contactsClient: contactsClient
        )
        controller.delegate = self
        return UINavigationController(
            rootViewController: controller
        )
    }
}

extension AppCoordinator: AuthClientDelegate {

    public func didLogin() {
        let controller = getContactsController()
        self.rootViewController = controller
        window.swapRootViewController(with: controller, animationType: .dismiss)
    }

    public func didLogout() {
        let controller = LoginController(authClient: authClient)
        self.rootViewController = controller
        window.swapRootViewController(with: rootViewController, animationType: .present)
    }
}

extension AppCoordinator: ContactsControllerDelegate {

    public func contactsController(_ controller: ContactsController, startConversationWith contacts: [Contact]) {
        let roomController = RoomController(contacts: contacts)
        roomController.modalPresentationStyle = .fullScreen
        controller.present(roomController, animated: true)
    }
}
