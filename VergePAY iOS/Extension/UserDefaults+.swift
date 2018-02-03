//
//  UserDefaults+.swift
//  VergePAY iOS
//
//  Created by Kentarou on 2018/02/07.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import Foundation

extension UserDefaults {
    enum key: String {
        case showMarket  = "ShowMarket"
        case showCalculate  = "ShowCalculate"
        case showAccount = "ShowAccount"
        case showHistory = "ShowHistory"
        
        case language   = "Language"
        case currency   = "Currency"
        case themeColor = "ThemeColor"
        
        case currentLanguage = "i18n_language"
        case address
    }
    
    enum UDLocalizedKey: String {
        case japanease = "ja"
        case english   = "en"
    }
    
    func defaultSetting() {
        UserDefaults.standard.register(defaults: [UserDefaults.key.showMarket.rawValue : true])
        UserDefaults.standard.register(defaults: [UserDefaults.key.showAccount.rawValue : true])
        UserDefaults.standard.register(defaults: [UserDefaults.key.showHistory.rawValue : true])
        
        var currency = "USD"
        var currentLocale = UDLocalizedKey.english.rawValue
        var currentLanguage = LocalizedKey.english.rawValue
        if Locale.current.identifier == "ja_JP" {
            currency = "JPY"
            currentLocale = UDLocalizedKey.japanease.rawValue
            currentLanguage = LocalizedKey.japanease.rawValue
        }
        
        UserDefaults.standard.register(defaults: [UserDefaults.key.currentLanguage.rawValue : currentLocale])
        
        UserDefaults.standard.register(defaults: [UserDefaults.key.language.rawValue : currentLanguage])
        UserDefaults.standard.register(defaults: [UserDefaults.key.currency.rawValue : currency])
        UserDefaults.standard.register(defaults: [UserDefaults.key.themeColor.rawValue : LocalizedKey.lightTheme.rawValue])
    }
    
    func setValue(key: UserDefaults.key, value: Bool) {
        set(value, forKey: key.rawValue)
        synchronize()
    }
    
    func getValue(key: UserDefaults.key) -> Bool {
        guard let value =  UserDefaults.standard.object(forKey: key.rawValue) as? Bool else { return true }
        return value
    }
    
    func setValue(key: UserDefaults.key, value: String) {
        set(value, forKey: key.rawValue)
        synchronize()
    }
    
    func getStringValue(key: UserDefaults.key) -> String {
        guard let value =  UserDefaults.standard.object(forKey: key.rawValue) as? String else { return "" }
        return value
    }
    
    func setlocalized(key: UDLocalizedKey) {
        set(key.rawValue, forKey: UserDefaults.key.currentLanguage.rawValue)
        synchronize()
    }
    
    var showMarket: Bool {
        get {
            let setKey = UserDefaults.key.showMarket
            if let showMarket =  UserDefaults.standard.object(forKey: setKey.rawValue) as? Bool {
                return showMarket
            }
            return true
        }
        set {
            setValue(newValue, forKeyPath: UserDefaults.key.showMarket.rawValue)
            synchronize()
        }
    }
    
    var showCalculate: Bool {
        get {
            let setKey = UserDefaults.key.showCalculate
            if let showMarket =  UserDefaults.standard.object(forKey: setKey.rawValue) as? Bool {
                return showMarket
            }
            return true
        }
        set {
            setValue(newValue, forKeyPath: UserDefaults.key.showCalculate.rawValue)
            synchronize()
        }
    }
    
    var showAccount: Bool {
        get {
            let setKey = UserDefaults.key.showAccount
            if let showMarket =  UserDefaults.standard.object(forKey: setKey.rawValue) as? Bool {
                return showMarket
            } else {
                return true
            }
        }
        set {
            setValue(newValue, forKeyPath: UserDefaults.key.showAccount.rawValue)
            synchronize()
        }
    }
    
    var showHistory: Bool {
        get {
            let setKey = UserDefaults.key.showHistory
            if let showMarket =  UserDefaults.standard.object(forKey: setKey.rawValue) as? Bool {
                return showMarket
            } else {
                return true
            }
        }
        set {
            setValue(newValue, forKeyPath: UserDefaults.key.showHistory.rawValue)
            synchronize()
        }
    }
    
    var themeColor: ThemeColor {
        get {
            let key = UserDefaults.key.themeColor
            guard let rawValue =  UserDefaults.standard.object(forKey: key.rawValue) as? String,
                let themeColor = ThemeColor(rawValue: rawValue) else {
                return .light
            }
            return themeColor
        }
        set(themeColor) {
            setValue(themeColor.rawValue, forKeyPath: UserDefaults.key.themeColor.rawValue)
            synchronize()
        }
    }
    
    var address: String? {
        get {
            let setKey = UserDefaults.key.address
            if let address =  UserDefaults.standard.object(forKey: setKey.rawValue) as? String {
                return address
            }
            return nil
        }
        set {
            setValue(newValue, forKeyPath: UserDefaults.key.address.rawValue)
            synchronize()
        }
    }
}
