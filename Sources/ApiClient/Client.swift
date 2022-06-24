//
//  Client.swift
//
//
//  Created by Roberto Casula on 16/06/22.
//

import Foundation
import UIKit

public protocol ApiClient {

    func login(
        username: String, password: String, completion: @escaping (Result<Void, ApiError>) -> Void)
    func logout(completion: @escaping (Result<Void, ApiError>) -> Void)
}
