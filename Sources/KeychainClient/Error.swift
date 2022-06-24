//
//  File.swift
//
//
//  Created by Roberto Casula on 19/06/22.
//

import Foundation

public enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
}
