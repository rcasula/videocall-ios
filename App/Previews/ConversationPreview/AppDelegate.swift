//
//  AppDelegate.swift
//  ConversationPreview
//
//  Created by Roberto Casula on 25/06/22.
//

import UIKit
import ConversationFeature

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        window.rootViewController = RoomController(
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
                )
            ]
        )
        window.makeKeyAndVisible()
        return true
    }

}

