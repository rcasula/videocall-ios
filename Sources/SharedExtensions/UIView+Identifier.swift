//
//  File.swift
//  
//
//  Created by Roberto Casula on 22/06/22.
//

import UIKit

public protocol Identifiable {
    static var identifier: String { get }
}

public extension Identifiable where Self: UIView {

    static var identifier: String { "\(self)" }
}

extension UIView: Identifiable {}
