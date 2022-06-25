//
//  File.swift
//  
//
//  Created by Roberto Casula on 25/06/22.
//

import Foundation
import SharedModels

protocol RoomDelegate: AnyObject {
    func didConnect()
    func didDisconnect()
    func room(_ room: Room, didAdd stream: Stream)
    func room(_ room: Room, didRemove stream: Stream)
}

class Room {

    let contacts: [Contact]
    var streams: [Stream] = []

    public weak var delegate: RoomDelegate?

    init(contacts: [Contact]) {
        self.contacts = contacts
    }

    public func connect() {
        delegate?.didConnect()
        contacts.forEach { [weak self] contact in
            guard let self = self else { return }
            let stream = Stream(contact: contact)
            self.streams.append(stream)
            self.delegate?.room(self, didAdd: stream)
        }
    }

    public func disconnect() {
        delegate?.didDisconnect()
    }
}
