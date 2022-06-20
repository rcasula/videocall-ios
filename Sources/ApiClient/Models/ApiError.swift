//
//  ApiError.swift
//  
//
//  Created by Roberto Casula on 17/06/22.
//

import Foundation

public enum ApiError: Error {
    case logoutUnsuccessful
    case invalidCredentials
    case unknown(error: Error)
}
