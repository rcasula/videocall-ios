//
//  ContactsClientTests.swift
//
//
//  Created by Roberto Casula on 15/06/22.
//

import SharedModels
import XCTest

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
        ),
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
                XCTFail("Get contacts failed")
            }
        }

        wait(for: [expectation], timeout: 0.5)
    }

    func testAddContact() {
        let newContact = Contact(
            name: "Test name",
            surname: "Test surname",
            avatarUrl: URL(string: "https://example.com")!
        )

        client?.add(contact: newContact)

        let expectation = XCTestExpectation(description: "Get contacts")

        client?.getContacts { result in
            switch result {
            case .success(let contacts):
                XCTAssertEqual(contacts, self.contacts)
                expectation.fulfill()
            case .failure:
                XCTFail("Get contacts failed")
            }
        }

        wait(for: [expectation], timeout: 0.5)
    }

    func testRemoveContact() {
        if let first = self.contacts.first {
            client?.remove(contact: first)
        }

        let expectation = XCTestExpectation(description: "Get contacts")

        client?.getContacts { result in
            switch result {
            case .success(let contacts):
                XCTAssertEqual(contacts, self.contacts)
                expectation.fulfill()
            case .failure:
                XCTFail("Get contacts failed")
            }
        }

        wait(for: [expectation], timeout: 0.5)
    }
}
