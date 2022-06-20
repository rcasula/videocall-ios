//
//  Contact.swift
//
//
//  Created by Roberto Casula on 15/06/22.
//

import Foundation

public struct Contact: Hashable, Equatable {
    public let id: UUID
    public let name: String
    public let surname: String
    public let avatarUrl: URL

    public init(
        id: UUID = .init(),
        name: String,
        surname: String,
        avatarUrl: URL
    ) {
        self.id = id
        self.name = name
        self.surname = surname
        self.avatarUrl = avatarUrl
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(surname)
        hasher.combine(avatarUrl)
    }
}
