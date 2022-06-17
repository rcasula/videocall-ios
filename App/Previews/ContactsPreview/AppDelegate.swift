//
//  AppDelegate.swift
//  ContactsPreview
//
//  Created by Roberto Casula on 15/06/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
//        window.rootViewController = coordinator.rootViewController
        window.makeKeyAndVisible()
        return true
    }

}

