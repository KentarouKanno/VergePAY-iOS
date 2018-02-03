//
//  NotificationTextField.swift
//  VergePAY iOS
//
//  Created by Kentarou on 2018/02/10.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import UIKit

class NotificationUpdateTextField: UITextField,
                                   NotificationUpdateProtocol {
    
    var localizedKey: LocalizedKey?
    var localizeText: String? {
        didSet {
            
            if let localizeText = localizeText {
                
                self.placeholder = localizeText.localized
                if let localizedKey = LocalizedKey(rawValue: localizeText) {
                    self.localizedKey = localizedKey
                } else {
                    localizedKey = nil
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialize()
    }
    
    func initialize() {
        localizedKey = nil
        
        if let placeholder = self.placeholder,
            let localizedKey = LocalizedKey(rawValue: placeholder) {
            self.localizedKey = localizedKey
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.update),
                                               name: .uiUpdateNotification,
                                               object: nil)
        
        update()
    }
    
    @objc func update() {
        
        if let localizedKey = localizedKey {
            self.attributedPlaceholder = NSAttributedString.attributedPlaceholder(text: localizedKey.rawValue.localized, isEnable: self.isEnabled)
        }
        
        switch UserDefaults.standard.themeColor {
        case .light:
            self.textColor = UIColor.ThemeColor.lightTextColor
            self.backgroundColor = UIColor.ThemeColor.lightBackColor
            if !self.isEnabled {
                self.backgroundColor = UIColor.ThemeColor.lightGrayBackColor
            }
        case .dark:
            self.textColor = UIColor.ThemeColor.darkTextColor
            self.backgroundColor = UIColor.ThemeColor.darkTextFieldBackColor
            if !self.isEnabled {
                self.backgroundColor = UIColor.ThemeColor.darkTextFieldDisableColor
            }
        }
    }
}
