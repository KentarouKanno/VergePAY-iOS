//
//  BlackTextLabel.swift
//  VergePAY iOS
//
//  Created by Kentarou on 2018/02/09.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

enum ThemeColor: String {
    case light = "LightTheme"
    case dark = "DarkTheme"
}

enum NotificationLabelType {
    case none
    case currencyCodeColonLabel
    case currencyCodeLabel
}

import Foundation
import UIKit

protocol NotificationUpdateProtocol {
    func update()
}

class NotificationUpdateLabel: UILabel, NotificationUpdateProtocol {
    
    var notificationLabelType: NotificationLabelType = .none
    var localizedKey: LocalizedKey?
    var localizeText: String? {
        didSet {
            
            if let localizeText = localizeText {
                
                self.text = localizeText.localized
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
        
        if let text = self.text,
            let localizedKey = LocalizedKey(rawValue: text) {
            self.localizedKey = localizedKey
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.update),
                                               name: .uiUpdateNotification,
                                               object: nil)
        update()
    }
    
    @objc func update() {
        
        switch UserDefaults.standard.themeColor {
        case .light: self.textColor = UIColor.ThemeColor.lightTextColor
        case .dark: self.textColor = UIColor.ThemeColor.darkTextColor
        }
        
        if let localizedKey = localizedKey {
            self.text = localizedKey.rawValue.localized
        }
        
        if case .currencyCodeColonLabel = self.notificationLabelType {
            self.text = UserDefaults.standard.getStringValue(key: .currency) + "："
        }
        
        if case .currencyCodeLabel = self.notificationLabelType {
            self.text = UserDefaults.standard.getStringValue(key: .currency)
        }
    }
}
