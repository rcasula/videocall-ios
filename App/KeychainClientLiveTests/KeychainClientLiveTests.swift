//
//  KeychainClientLiveTests.swift
//  KeychainClientLiveTests
//
//  Created by Roberto Casula on 19/06/22.
//

import XCTest
import KeychainClient
@testable import KeychainClientLive

class KeychainClientLiveTests: XCTestCase {

    let client: KeychainClient = KeychainClientLive()

    override func tearDownWithError() throws {
        try client.deleteCredentials(for: "jshier")
    }

    func testSaveCredentials() {
        XCTAssertNoThrow(
            try client.saveCredentials(username: "jshier", password: "12345")
        )
        let credentials = client.getCredentials(for: "jshier")

        XCTAssertNotNil(credentials)
        XCTAssertEqual(credentials?.username, "jshier")
        XCTAssertEqual(credentials?.password, "12345")
    }

    func testDuplicateCredentials() {
        let client: KeychainClient = KeychainClientLive()

        XCTAssertNoThrow(
            try client.saveCredentials(username: "jshier", password: "12345")
        )
        XCTAssertNoThrow(
            try client.saveCredentials(username: "jshier", password: "12345")
        )

        let credentials = client.getCredentials(for: "jshier")

        XCTAssertNotNil(credentials)
        XCTAssertEqual(credentials?.username, "jshier")
        XCTAssertEqual(credentials?.password, "12345")
    }
}
