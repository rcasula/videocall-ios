//
//  AuthClient.swift
//
//
//  Created by Roberto Casula on 16/06/22.
//

import ApiClient
import Foundation
import KeychainClient
import PersistenceClient
import Security

public protocol AuthClientDelegate: AnyObject {
    func didLogin()
    func didLogout()
}

public protocol AuthClientProtocol {

    var delegate: AuthClientDelegate? { get set }

    init(
        apiClient: ApiClient,
        keychainClient: KeychainClient,
        persistenceClient: PersistenceClient,
        rememberCredentials: Bool
    )

    func login(
        username: String, password: String, completion: @escaping (Result<Void, ApiError>) -> Void)
    func logout() throws

    func getSavedCredentials() -> (username: String, password: String)?
}

public class AuthClient: AuthClientProtocol {

    private let apiClient: ApiClient
    private let keychainClient: KeychainClient
    private let persistenceClient: PersistenceClient
    private let rememberCredentials: Bool

    public weak var delegate: AuthClientDelegate?

    required public init(
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
        ) { [weak self] result in
            switch result {
            case .success:
                do {
                    try self?.saveCredentials(username: username, password: password)
                    self?.delegate?.didLogin()
                } catch let error {
                    debugPrint(error)
                }
            case .failure:
                break
            }
            completion(result)
        }
    }

    public func logout() throws {
        guard let username = persistenceClient.username
        else { return }
        try keychainClient.deleteCredentials(for: username)
        persistenceClient.deleteUsername()
        delegate?.didLogout()
    }

    public func getSavedCredentials() -> (username: String, password: String)? {
        guard let username = persistenceClient.username
        else { return nil }
        return keychainClient.getCredentials(for: username)
    }

    private func saveCredentials(username: String, password: String) throws {
        guard rememberCredentials else { return }
        persistenceClient.save(username: username)
        try keychainClient.saveCredentials(username: username, password: password)
    }
}
