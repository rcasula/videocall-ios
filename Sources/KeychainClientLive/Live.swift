//
//  File.swift
//
//
//  Created by Roberto Casula on 19/06/22.
//

import Foundation
import KeychainClient
import Security

public struct KeychainClientLive: KeychainClient {

    public init() {}

    public func saveCredentials(username: String, password: String) throws {
        guard getCredentials(for: username) == nil
        else { return }
        guard let passwordData = password.data(using: .utf8)
        else { throw KeychainError.unexpectedPasswordData }
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
            kSecValueData as String: passwordData,
        ]

        let status = SecItemAdd(attributes as CFDictionary, nil)
        guard status == errSecSuccess
        else { throw KeychainError.unhandledError(status: status) }
    }

    public func getCredentials(for username: String) -> (username: String, password: String)? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true,
        ]
        var item: CFTypeRef?

        guard SecItemCopyMatching(query as CFDictionary, &item) == noErr,
            let existingItem = item as? [String: Any],
            let username = existingItem[kSecAttrAccount as String] as? String,
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: .utf8)
        else { return nil }
        return (username, password)
    }

    public func deleteCredentials(for username: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
        ]

        let result = SecItemDelete(query as CFDictionary)
        guard result == noErr
        else { throw KeychainError.unhandledError(status: result) }
    }
}
