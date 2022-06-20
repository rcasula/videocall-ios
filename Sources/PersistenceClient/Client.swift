//
//  File.swift
//  
//
//  Created by Roberto Casula on 19/06/22.
//

import Foundation

public struct PersistenceClient {

    private let userDefaults: UserDefaults

    public var username: String? {
        userDefaults.string(forKey: "dev.casula.videocall.username")
    }

    public init(
        userDefaults: UserDefaults = .init()
    ) {
        self.userDefaults = userDefaults
    }

    public func save(username: String) {
        userDefaults.set(username, forKey: "dev.casula.videocall.username")
    }

    public func deleteUsername() {
        userDefaults.removeObject(forKey: "dev.casula.videocall.username")
    }
}
