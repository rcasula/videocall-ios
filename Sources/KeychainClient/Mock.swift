//
//  File.swift
//  
//
//  Created by Roberto Casula on 19/06/22.
//

import Foundation

public class MockKeychainClient: KeychainClient {

    private var credentials: [String: String] = [:]

    public init() {}

    public func saveCredentials(username: String, password: String) throws {
        credentials[username] = password
    }

    public func getCredentials(for username: String) -> (username: String, password: String)? {
        guard let password = credentials[username]
        else { return nil }
        return (username, password)
    }

    public func deleteCredentials(for username: String) throws {
        credentials.removeValue(forKey: username)
    }
}
