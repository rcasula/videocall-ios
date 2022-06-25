//
//  File.swift
//
//
//  Created by Roberto Casula on 25/06/22.
//

import UIKit

extension UICollectionView {

    /**
    Register cell class by passing the type
     - Parameter type: UICollectionViewCell.Type
     */
    public func registerCell<T>(type: T.Type) where T: UICollectionViewCell {
        let cell = type.identifier
        register(type.self, forCellWithReuseIdentifier: cell)
    }

    /**
     DequeueCell by passing the type of UICollectionViewCell
     - Parameter type: UICollectionViewCell.Type
     - Parameter type: IndexPath
     */
    public func dequeueCell<T>(withType type: T.Type, for indexPath: IndexPath) -> T?
    where T: UICollectionViewCell {
        return dequeueReusableCell(withReuseIdentifier: type.identifier, for: indexPath) as? T
    }
}
