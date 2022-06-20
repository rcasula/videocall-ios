//
//  MockApiClient.swift
//  
//
//  Created by Roberto Casula on 17/06/22.
//

import Foundation

public struct MockApiClient: ApiClient {

    private let enabledUsers: [String: String]
    private let enableDelay: Bool

    public init(
        enabledUsers: [String: String] = [:],
        enableDelay: Bool = false
    ) {
        self.enabledUsers = enabledUsers
        self.enableDelay = enableDelay
    }

    public func login(username: String, password: String, completion: @escaping (Result<Void, ApiError>) -> Void) {
        if enableDelay {
            let randomSeconds = Double.random(in: 1.0...3.5)
            DispatchQueue.main.asyncAfter(deadline: .now() + randomSeconds) {
                loginSync(username: username, password: password, completion: completion)
            }
        } else {
            loginSync(username: username, password: password, completion: completion)
        }
    }

    private func loginSync(username: String, password: String, completion: @escaping (Result<Void, ApiError>) -> Void) {
        guard let validPassword = enabledUsers[username],
              validPassword == password
        else { completion(.failure(.invalidCredentials)); return }
        completion(.success(()))
    }

    public func logout(completion: @escaping (Result<Void, ApiError>) -> Void) {
        completion(.success(()))
    }
}
