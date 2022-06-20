//
//  AuthClient.swift
//  
//
//  Created by Roberto Casula on 16/06/22.
//

import Security
import ApiClient
import Foundation
import KeychainClient
import PersistenceClient

public protocol AuthClientProtocol {

    init(
        apiClient: ApiClient,
        keychainClient: KeychainClient,
        persistenceClient: PersistenceClient,
        rememberCredentials: Bool
    )

    func login(username: String, password: String, completion: @escaping (Result<Void, ApiError>) -> Void)
    func logout() throws

    func getSavedCredentials() -> (username: String, password: String)?
}

public struct AuthClient: AuthClientProtocol {

    private let apiClient: ApiClient
    private let keychainClient: KeychainClient
    private let persistenceClient: PersistenceClient
    private let rememberCredentials: Bool

    public init(
        apiClient: ApiClient,
        keychainClient: KeychainClient,
        persistenceClient: PersistenceClient,
        rememberCredentials: Bool = true
    ) {
        self.apiClient = apiClient
        self.keychainClient = keychainClient
        self.persistenceClient = persistenceClient
        self.rememberCredentials = rememberCredentials
    }

    public func login(
        username: String,
        password: String,
        completion: @escaping (Result<Void, ApiError>) -> Void
    ) {
        apiClient.login(
            username: username,
            password: password
        ) { result in
            do {
                try saveCredentials(username: username, password: password)
            } catch let error {
                debugPrint(error)
            }
            completion(result)
        }
    }

    public func logout() throws {
        guard let username = persistenceClient.username
        else { return }
        try keychainClient.deleteCredentials(for: username)
        persistenceClient.deleteUsername()
    }

    public func getSavedCredentials() -> (username: String, password: String)? {
        guard let username = persistenceClient.username
        else { return nil }
        return keychainClient.getCredentials(for: username)
    }

    private func saveCredentials(username: String, password: String) throws {
        persistenceClient.save(username: username)
        try keychainClient.saveCredentials(username: username, password: password)
    }
}
