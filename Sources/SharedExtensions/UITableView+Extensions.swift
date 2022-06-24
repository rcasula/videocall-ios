//
//  File.swift
//
//
//  Created by Roberto Casula on 22/06/22.
//

import UIKit

extension UITableView {

    /// Register cell class by passing the type
    /// - Parameter type: The cell's type
    public func registerCell<T>(type: T.Type) where T: UITableViewCell {
        let cell = type.identifier
        register(type.self, forCellReuseIdentifier: cell)
    }

    /// DequeueCell by passing the type of UITableViewCell
    /// - Parameter type: the cell's type
    /// - Returns: A typed table view cell
    public func dequeueCell<T>(withType type: T.Type) -> T? where T: UITableViewCell {
        return dequeueReusableCell(withIdentifier: type.identifier) as? T
    }

    /// DequeueCell by passing the type of UITableViewCell and IndexPath
    /// - Parameters:
    ///   - type: The cell's type
    ///   - indexPath: The index path
    /// - Returns: A typed table view cell
    public func dequeueCell<T>(withType type: T.Type, for indexPath: IndexPath) -> T?
    where T: UITableViewCell {
        return dequeueReusableCell(withIdentifier: type.identifier, for: indexPath) as? T
    }
}
