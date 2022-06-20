//
//  File.swift
//
//
//  Created by Roberto Casula on 15/06/22.
//

import Foundation
import SharedModels

public struct MockContactsClient: ContactsClient {

    private let contacts: [Contact]
    private let enableDelay: Bool

    public init(
        contacts: [Contact]? = nil,
        enableDelay: Bool = false
    ) {
        self.contacts = contacts ?? Self.defaultMocks
        self.enableDelay = enableDelay
    }

    public func getContacts(_ completion: @escaping (Result<[Contact], Error>) -> Void) {
        if enableDelay {
            let randomSeconds = Double.random(in: 1.0...3.5)
            DispatchQueue.main.asyncAfter(deadline: .now() + randomSeconds) {
                completion(.success(contacts))
            }
        } else {
            completion(.success(contacts))
        }
    }

    public func add(contact: Contact) {
        self.contacts.append(contact)
    }

    public func remove(contact: Contact) {
        self.contacts.removeAll(where: { $0 == contact })
    }
}

extension MockContactsClient {

    fileprivate static let defaultMocks: [Contact] = [
        .init(
            name: "Katherine",
            surname: "Wells",
            avatarUrl: URL(
                string:
                    "https://avatars.dicebear.com/v2/female/42d4dbac162c3ebc57ebe9c00ee02cdc.svg")!
        ),
        .init(
            name: "Samantha",
            surname: "Butler",
            avatarUrl: URL(
                string:
                    "https://avatars.dicebear.com/v2/female/a1462e1050b1fa099c8b53a3fb3c3465.svg")!
        ),
        .init(
            name: "Victoria",
            surname: "Holt",
            avatarUrl: URL(
                string:
                    "https://avatars.dicebear.com/v2/female/24fc0c093c01be351a9ce865934fc8b6.svg")!
        ),
        .init(
            name: "Nathan",
            surname: "Gray",
            avatarUrl: URL(
                string:
                    "https://avatars.dicebear.com/v2/female/4cf395fbc3256b42f260e90b7c1c9ff7.svg")!
        ),
        .init(
            name: "Jeffrey",
            surname: "Cannon",
            avatarUrl: URL(
                string: "https://avatars.dicebear.com/v2/male/42d4dbac162c3ebc57ebe9c00ee02cdc.svg")!
        ),
        .init(
            name: "James",
            surname: "Baldwin",
            avatarUrl: URL(
                string: "https://avatars.dicebear.com/v2/male/944428cf2a61d0d0b587d9370b74dc86.svg")!
        ),
        .init(
            name: "Shane",
            surname: "Brown",
            avatarUrl: URL(
                string: "https://avatars.dicebear.com/v2/male/1e59f744d9cc6abc632dc551e19516ba.svg")!
        ),
    ]
}
