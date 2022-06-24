//
//  File.swift
//
//
//  Created by Roberto Casula on 21/06/22.
//

import UIKit

public protocol Coordinator {
    var rootViewController: UIViewController { get }
    func start()
}
