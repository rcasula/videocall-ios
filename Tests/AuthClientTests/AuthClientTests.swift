//
//  AuthClientTests.swift
//  
//
//  Created by Roberto Casula on 16/06/22.
//

import XCTest
import ApiClient
import KeychainClient
import PersistenceClient
@testable import AuthClient

class AuthClientTests: XCTestCase {

    override func setUpWithError() throws {

    }

    func testSuccessfullLogin() {
        let apiClient: ApiClient = MockApiClient(
            enabledUsers: [
                "jshier": "123456"
            ]
        )
        let mockKeychainClient: KeychainClient = MockKeychainClient()
        let persistenceClient = PersistenceClient()
        let authClient = AuthClient(
            apiClient: apiClient,
            keychainClient: mockKeychainClient,
            persistenceClient: persistenceClient
        )
        let expectation = XCTestExpectation(description: "Login successful")
        authClient.login(
            username: "jshier",
            password: "123456"
        ) { result in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Login failed: \(error)")
            }
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testFailedLogin() {
        let apiClient: ApiClient = MockApiClient(
            enabledUsers: [
                "jshier": "123456"
            ]
        )
        let mockKeychainClient: KeychainClient = MockKeychainClient()
        let persistenceClient = PersistenceClient()
        let authClient = AuthClient(
            apiClient: apiClient,
            keychainClient: mockKeychainClient,
            persistenceClient: persistenceClient
        )
        let expectation = XCTestExpectation(description: "Login failed")
        authClient.login(
            username: "jshier",
            password: "1234567"
        ) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                switch error {
                case .invalidCredentials:
                    expectation.fulfill()
                default:
                    XCTFail("Login failed: \(error)")
                }
            }
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testRememberCredentials() {
        let apiClient: ApiClient = MockApiClient(
            enabledUsers: [
                "jshier": "123456"
            ]
        )
        let mockKeychainClient: KeychainClient = MockKeychainClient()
        let persistenceClient = PersistenceClient()
        let authClient = AuthClient(
            apiClient: apiClient,
            keychainClient: mockKeychainClient,
            persistenceClient: persistenceClient
        )
        let expectation = XCTestExpectation(description: "Login successful")
        authClient.login(
            username: "jshier",
            password: "123456"
        ) { result in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Login failed: \(error.localizedDescription)")
            }
        }
        wait(for: [expectation], timeout: 0.5)

        let user = authClient.getSavedCredentials()
        XCTAssertNotNil(user)
        XCTAssertEqual(user?.username, "jshier")
        XCTAssertEqual(user?.password, "123456")
    }

    func testLogout() {
        let apiClient: ApiClient = MockApiClient(
            enabledUsers: [
                "jshier": "123456"
            ]
        )
        let mockKeychainClient: KeychainClient = MockKeychainClient()
        let persistenceClient = PersistenceClient()
        let authClient = AuthClient(
            apiClient: apiClient,
            keychainClient: mockKeychainClient,
            persistenceClient: persistenceClient
        )
        let expectation = XCTestExpectation(description: "Login successful")
        authClient.login(
            username: "jshier",
            password: "123456"
        ) { result in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Login failed: \(error.localizedDescription)")
            }
        }
        wait(for: [expectation], timeout: 0.5)

        XCTAssertNotNil(authClient.getSavedCredentials())

        XCTAssertNoThrow(try authClient.logout())
        XCTAssertNil(authClient.getSavedCredentials())
    }
}
