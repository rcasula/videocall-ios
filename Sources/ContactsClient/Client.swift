//
//  Client.swift
//
//
//  Created by Roberto Casula on 15/06/22.
//

import Foundation
import SharedModels

public protocol ContactsClient {

    func getContacts(_ completion: @escaping (Result<[Contact], Error>) -> Void)

    func add(contact: Contact)
    func remove(contact: Contact)
}
