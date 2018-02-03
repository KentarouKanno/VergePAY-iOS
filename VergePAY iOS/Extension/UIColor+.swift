//
//  UIColor+.swift
//  VergePAY iOS
//
//  Created by Kentarou on 2018/02/09.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import Foundation


import UIKit

extension UIColor {
    
    struct ThemeColor {
        private init() {}
        
        // TextColor
        static let lightTextColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        static let darkTextColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        // View Background
        static let lightBackColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        static let darkBackColor = #colorLiteral(red: 0.179236114, green: 0.2108162642, blue: 0.2648339272, alpha: 1)
        
        // TextField Background
        static let lightTextFieldBackColor = #colorLiteral(red: 0.9432497398, green: 0.9432497398, blue: 0.9432497398, alpha: 1)
        static let darkTextFieldBackColor = #colorLiteral(red: 0.3058823529, green: 0.3286581039, blue: 0.3743763864, alpha: 1)
        
        // TextField Dark Disable
        static let darkTextFieldDisableColor = #colorLiteral(red: 0.1987672195, green: 0.2223182335, blue: 0.2685856432, alpha: 1)
        
        static let lightGrayBackColor = #colorLiteral(red: 0.9432497398, green: 0.9432497398, blue: 0.9432497398, alpha: 1)
        static let darkGrayBackColor = #colorLiteral(red: 0.3050314188, green: 0.3286581039, blue: 0.3743763864, alpha: 1)
        
        // TextField Placeholder
        static let lightPlaceholderColor = #colorLiteral(red: 0.7977672906, green: 0.7977672906, blue: 0.7977672906, alpha: 1)
        static let darkPlaceholderColor = #colorLiteral(red: 0.3787817542, green: 0.4223333169, blue: 0.488595866, alpha: 1)
        static let darkPlaceholderDisableColor = #colorLiteral(red: 0.283610655, green: 0.315543571, blue: 0.3718644257, alpha: 1)
        
        // Progress
        static let progressLightForeColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        static let progressLightBackColor = #colorLiteral(red: 0.9456446767, green: 0.9402881265, blue: 0.9497665763, alpha: 1)
        static let progressDarkForeColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        static let progressDarkBackColor = #colorLiteral(red: 0.6661143264, green: 0.659647197, blue: 0.6725814557, alpha: 1)
    }
}
