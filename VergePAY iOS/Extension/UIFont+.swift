//
//  UIFont+.swift
//  VergePAY iOS
//
//  Created by Kentarou on 2018/02/20.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    
    static func avenirNextFont(size: CGFloat) -> UIFont {
        if let font  = UIFont(name: "Avenir Next", size: size) {
            return font
        }
        return UIFont.systemFont(ofSize: size)
    }
}
