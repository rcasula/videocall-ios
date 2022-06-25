//
//  File.swift
//
//
//  Created by Roberto Casula on 25/06/22.
//

import UIKit

extension UIView {
    public func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(
            roundedRect: bounds, byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
