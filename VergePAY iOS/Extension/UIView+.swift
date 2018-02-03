//
//  UIView+.swift
//  QRScan
//
//  Created by Kentarou on 2018/01/28.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    // borderColor
    @IBInspectable var borderColor: UIColor? {
        get { return layer.borderColor.map{ UIColor(cgColor: $0) } }
        set (color){ layer.borderColor = color?.cgColor }
    }
    
    // borderwidth
    @IBInspectable var borderwidth: CGFloat {
        get { return layer.borderWidth }
        set(borderWidth) { layer.borderWidth = borderWidth }
    }
    
    // cornerRadius
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set(cornerRadius) { layer.cornerRadius = cornerRadius}
    }
    
    // masksToBounds
    @IBInspectable var masksToBounds: Bool {
        get { return layer.masksToBounds }
        set (masksToBounds) { layer.masksToBounds = masksToBounds}
    }
    
    // Flash Animation
    func flash(duration: TimeInterval = 0.8) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: duration) {
                self.alpha = 0.0
            }
        }
    }
}
