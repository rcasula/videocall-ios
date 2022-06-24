//
//  File.swift
//  
//
//  Created by Roberto Casula on 19/06/22.
//

import Foundation

public protocol KeychainClient {
    func saveCredentials(username: String, password: String) throws
    func getCredentials(for username: String) -> (username: String, password: String)?
    func deleteCredentials(for username: String) throws
}
