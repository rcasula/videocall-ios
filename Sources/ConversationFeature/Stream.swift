//
//  File.swift
//  
//
//  Created by Roberto Casula on 25/06/22.
//

import Foundation
import SharedModels

class Stream: Equatable {

    private let contact: Contact

    public var hasAudio: Bool
    public var hasVideo: Bool

    init(contact: Contact) {
        self.contact = contact
        self.hasAudio = true
        self.hasVideo = true
    }

    static func == (lhs: Stream, rhs: Stream) -> Bool {
        return lhs.contact == rhs.contact
    }
}
