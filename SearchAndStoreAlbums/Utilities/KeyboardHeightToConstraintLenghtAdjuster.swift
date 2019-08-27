//
//  KeyboardHeightToConstraintLenghtAdjuster.swift
//  SearchAndStoreAlbums
//
//  Created by Dimic Milos on 8/27/19.
//  Copyright © 2019 Dimic Milos. All rights reserved.
//

import os
import UIKit

class KeyboardHeightToConstraintLenghtAdjuster {
    
    let viewController: UIViewController
    let constraint: NSLayoutConstraint
    let padding: CGFloat
    
    init(viewController: UIViewController, constraint: NSLayoutConstraint, padding: CGFloat = 0) {
        os_log(.info, log: .initialization, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        self.viewController = viewController
        self.constraint = constraint
        self.padding = padding
    }
    
    func animate(for notification: NSNotification) {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        guard let userInfo = notification.userInfo,
            let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber,
            let keyboardFrameEnd = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let rawAnimationCurve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey]  as? UInt else {
                return
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification {
            constraint.constant = keyboardFrameEnd.cgRectValue.height + padding
        } else if notification.name == UIResponder.keyboardWillHideNotification {
            constraint.constant = padding
        }
        
        UIView.animate(withDuration: animationDuration.doubleValue, delay: 0.7, options: [.beginFromCurrentState, UIView.AnimationOptions.init(rawValue: rawAnimationCurve)], animations: { [weak self] in
            self?.viewController.view.layoutIfNeeded()
            }, completion: nil)
    }
}
