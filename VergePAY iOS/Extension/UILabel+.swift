//
//  UILabel+.swift
//  QRScan
//
//  Created by Kentarou on 2018/02/03.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    static var flashTimeInterval: TimeInterval = 0.8
    
    func plusFlash(text: String? = nil) {
        
        UIView.transition(with: self,
                          duration: UILabel.flashTimeInterval,
                          options: .transitionCrossDissolve,
                          animations: {
                            if let text = text {
                                self.text = text
                            }
                            self.textColor = #colorLiteral(red: 0.5396745356, green: 0.8916489016, blue: 0.3121336799, alpha: 1)
        }, completion: { (finished) in
            
            UIView.transition(with: self,
                              duration: UILabel.flashTimeInterval,
                              options: .transitionCrossDissolve,
                              animations: {
                                
                                self.setTextColor()
            }, completion: { _ in })
        })
    }
    
    func minusFlash(text: String? = nil) {
        
        UIView.transition(with: self,
                          duration: UILabel.flashTimeInterval,
                          options: .transitionCrossDissolve,
                          animations: {
                            if let text = text {
                                self.text = text
                            }
                            self.textColor = #colorLiteral(red: 0.9822497673, green: 0.3285003635, blue: 0.35686782, alpha: 1)
        }, completion: { (finished) in
            
            UIView.transition(with: self,
                              duration: UILabel.flashTimeInterval,
                              options: .transitionCrossDissolve,
                              animations: {
                                
                                self.setTextColor()
            }, completion: { _ in })
        })
    }
    
    func setTextColor() {
        switch UserDefaults.standard.themeColor {
        case .light: self.textColor = UIColor.ThemeColor.lightTextColor
        case .dark: self.textColor = UIColor.ThemeColor.darkTextColor
        }
    }
}
