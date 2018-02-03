//
//  SettingCellData.swift
//  VergePAY iOS
//
//  Created by Kentarou on 2018/02/08.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import Foundation

enum PickerType {
    case language
    case currency
    case colorTheme
}

class SettingCellData {
    var title: String = ""
    var value: String = ""
    var list: [String] = []
    var userDefaultKey: UserDefaults.key
    var pickerType: PickerType?
    
    init(title: String,
         value: String = "",
         list: [String] = [],
         userDefaultKey: UserDefaults.key,
         pickerType: PickerType? = nil) {
        
        self.title = title
        self.value = value
        self.list = list
        self.userDefaultKey = userDefaultKey
        self.pickerType = pickerType
    }
}

class SettingCellItem: NotificationUpdateProtocol {
    
    var headerTitleList: [String] = ["DisplaySetting", "AppSetting"]
    
    var dataList: [[String]] = [[LocalizedKey.english.rawValue,
                                 LocalizedKey.japanease.rawValue],
                                [],
                                [LocalizedKey.lightTheme.rawValue,
                                    LocalizedKey.darkTheme.rawValue]]
    
    
    var displaySettingCellList: [SettingCellData] = []
    private var displaySettingTitleList: [String] = ["Market", "Calculate", "Account", "History"]
    private var displaySettingtKey: [UserDefaults.key] = [UserDefaults.key.showMarket,
                                                          UserDefaults.key.showCalculate,
                                                          UserDefaults.key.showAccount,
                                                          UserDefaults.key.showHistory]
    
    var appSettingCellList: [SettingCellData] = []
    private let appSettingTitleList = ["Language", "Currency", "ColorTheme"]
    private let appSettingPickerType: [PickerType] = [.language, .currency, .colorTheme]
    private var appSettingtKey: [UserDefaults.key] = [UserDefaults.key.language,
                                                      UserDefaults.key.currency,
                                                      UserDefaults.key.themeColor]
    
    var language: String = ""
    var currency: String = ""
    var colorTheme: String = ""
    
    var languageList: [String] = []
    var currencyList: [String] = []
    var colorThemeList: [String] = []
    
    init(currencyData: CountryConvertData) {
        
        dataList[1] = currencyData.CurrencyList
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.update),
                                               name: .uiUpdateNotification,
                                               object: nil)
        
        for index in 0...displaySettingTitleList.count {
            if let title = displaySettingTitleList[safe: index],
                let key = displaySettingtKey[safe: index] {
                let cellData = SettingCellData(title: title,
                                               userDefaultKey: key)
                displaySettingCellList.append(cellData)
            }
        }
        
        for index in 0...appSettingTitleList.count {
            
            if let title = appSettingTitleList[safe: index],
                let key = appSettingtKey[safe: index],
                let list = dataList[safe: index],
                let pickerType = appSettingPickerType[safe: index] {
                
                let cellData = SettingCellData(title: title,
                                               value: UserDefaults.standard.getStringValue(key: key),
                                               list: list,
                                               userDefaultKey: key,
                                               pickerType: pickerType)
                appSettingCellList.append(cellData)
            }
        }
        
        update()
    }
    
    @objc func update() {
        
    }
}
