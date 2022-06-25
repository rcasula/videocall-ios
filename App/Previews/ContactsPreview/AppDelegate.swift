//
//  AppDelegate.swift
//  ContactsPreview
//
//  Created by Roberto Casula on 15/06/22.
//

import UIKit
import ContactsFeature

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        window.rootViewController = ContactsController(
            authClient: AuthClient(
                apiClient: MockApiClient(
                    enabledUsers: [
                        "jshier": "123456"
                    ],
                    enableDelay: true
                ),
                keychainClient: MockKeychainClient(),
                persistenceClient: PersistenceClient(),
                rememberCredentials: true
            ),
            contactsClient: .init(
                contacts: [
                    .init(
                        name: "Katherine",
                        surname: "Wells",
                        avatarUrl: URL(string: "https://www.gravatar.com/avatar/a?s=50&d=identicon&r=PG")!
                    ),
                    .init(
                        name: "Samantha",
                        surname: "Butler",
                        avatarUrl: URL(string: "https://www.gravatar.com/avatar/b?s=50&d=identicon&r=PG")!
                    ),
                    .init(
                        name: "Victoria",
                        surname: "Holt",
                        avatarUrl: URL(string: "https://www.gravatar.com/avatar/c?s=50&d=identicon&r=PG")!
                    ),
                    .init(
                        name: "Nathan",
                        surname: "Gray",
                        avatarUrl: URL(string: "https://www.gravatar.com/avatar/d?s=50&d=identicon&r=PG")!
                    ),
                    .init(
                        name: "Jeffrey",
                        surname: "Cannon",
                        avatarUrl: URL(string: "https://www.gravatar.com/avatar/e?s=50&d=identicon&r=PG")!
                    ),
                    .init(
                        name: "James",
                        surname: "Baldwin",
                        avatarUrl: URL(string: "https://www.gravatar.com/avatar/f?s=50&d=identicon&r=PG")!
                    ),
                    .init(
                        name: "Shane",
                        surname: "Brown",
                        avatarUrl: URL(string: "https://www.gravatar.com/avatar/g?s=50&d=identicon&r=PG")!
                    )
                ],
                enableDelay: true
            )
        )
        window.makeKeyAndVisible()
        return true
    }

}
