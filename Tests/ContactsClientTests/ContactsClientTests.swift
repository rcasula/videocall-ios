//
//  ContactsClientTests.swift
//  
//
//  Created by Roberto Casula on 15/06/22.
//

import XCTest
import SharedModels
@testable import ContactsClient

class ContactsClientTests: XCTestCase {

    let contacts: [Contact] = [
        .init(
            name: "Katherine",
            surname: "Wells",
            avatarUrl: URL(string: "https://example.com")!
        ),
        .init(
            name: "James",
            surname: "Baldwin",
            avatarUrl: URL(string: "https://example.com")!
        ),
        .init(
            name: "Shane",
            surname: "Brown",
            avatarUrl: URL(string: "https://example.com")!
        )
    ]

    var client: ContactsClient?

    override func setUpWithError() throws {
        client = MockContactsClient(contacts: contacts)
    }

    func testGetContacts() throws {
        let expectation = XCTestExpectation(description: "Get contacts")

        client?.getContacts { result in
            switch result {
            case .success(let contacts):
                XCTAssertEqual(contacts, self.contacts)
                expectation.fulfill()
            case .failure:
                break
            }
        }

        wait(for: [expectation], timeout: 0.5)
    }

}
