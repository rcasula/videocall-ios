//
//  UIWindow+SwapViewController.swift
//  WeBus
//
//  Created by Roberto Casula on 16/07/17.
//  Copyright © 2017 Roberto Casula. All rights reserved.
//

import UIKit

public enum SwapRootVCAnimationType {
    case push
    case pop
    case present
    case dismiss
}

extension UIWindow {

    public func swapRootViewController(with new: UIViewController?) {
        self.rootViewController = new
        self.makeKeyAndVisible()
    }

    public func swapRootViewController(
        with newViewController: UIViewController, animationType: SwapRootVCAnimationType,
        completion: (() -> Void)? = nil
    ) {

        guard let currentViewController = rootViewController else { return }

        let width = currentViewController.view.frame.size.width
        let height = currentViewController.view.frame.size.height

        var newVCStartAnimationFrame: CGRect?
        var currentVCEndAnimationFrame: CGRect?

        var newVCAnimated = true

        switch animationType {
        case .push:
            newVCStartAnimationFrame = CGRect(x: width, y: 0, width: width, height: height)
            currentVCEndAnimationFrame = CGRect(
                x: 0 - width / 4, y: 0, width: width, height: height)
            break

        case .pop:
            currentVCEndAnimationFrame = CGRect(x: width, y: 0, width: width, height: height)
            newVCStartAnimationFrame = CGRect(x: 0 - width / 4, y: 0, width: width, height: height)
            newVCAnimated = false
            break

        case .present:
            newVCStartAnimationFrame = CGRect(x: 0, y: height, width: width, height: height)
            break

        case .dismiss:
            currentVCEndAnimationFrame = CGRect(x: 0, y: height, width: width, height: height)
            newVCAnimated = false
            break
        }

        newViewController.view.frame =
            newVCStartAnimationFrame ?? CGRect(x: 0, y: 0, width: width, height: height)

        addSubview(newViewController.view)

        if !newVCAnimated {
            bringSubviewToFront(currentViewController.view)
        }

        UIView.animate(
            withDuration: 0.3, delay: 0, options: [.curveEaseOut],
            animations: {
                if let currentVCEndAnimationFrame = currentVCEndAnimationFrame {
                    currentViewController.view.frame = currentVCEndAnimationFrame
                }

                newViewController.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
            },
            completion: { finish in
                self.rootViewController = newViewController
                completion?()
            })

        makeKeyAndVisible()
    }
}
