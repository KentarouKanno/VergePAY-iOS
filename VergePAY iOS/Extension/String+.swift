//
//  String+.swift
//  QRScan
//
//  Created by Kentarou on 2018/01/28.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import Foundation

enum LocalizedKey: String {
    case defaultLanguage = "DefaultLanguage"
    case market = "Market"
    case calculate = "Calculate"
    case account = "Account"
    case history = "History"
    case displaySetting = "DisplaySetting"
    case appSetting = "AppSetting"
    case language = "Language"
    case currency = "Currency"
    case colorTheme = "ColorTheme"
    case address = "Address"
    case qRCode = "QR Code"
    case sendXVG = "Send XVG"
    case paymentIn = "Payment In"
    case paymentOut = "Payment Out"
    case historyHeaderDetailTitle = "History Header Detail Title"
    case historyNone = "History None"
    case japanease = "Japanease"
    case english = "English"
    case lightTheme = "LightTheme"
    case darkTheme = "DarkTheme"
    case cancel = "Cancel"
    case toSettings = "toSettings"
    case cameraAlertTitle = "CameraAlertTitle"
    case cameraAlertMessage = "CameraAlertMessage"
    case photoAlertTitle = "PhotoAlertTitle"
    case photoAlertMessage = "PhotoAlertMessage"
    case payTextFieldPlaceholder = "PayTextFieldPlaceholder"
    case XVGAddress = "XVG Address"
    case addressCopy = "Copy Address Message"
    case noContentsMessage = "NoContentsMessage"
    case camera = "Camera"
    case photo = "Photo"
    case qrReadFailed = "QRReadFailed"
}

extension String {

    // 2nd Dec 2017 08:31:03 → 2 Dec 2017 08:31:03
    func convertDateFormat() -> String {
        
        var dateArray = self.components(separatedBy: " ").filter { !$0.isEmpty }
        
        if let date = dateArray.first {
            let splitNumbers = (date.components(separatedBy: NSCharacterSet.decimalDigits.inverted))
            dateArray[0] = splitNumbers.joined()
        }
        return dateArray.joined(separator: " ")
    }
    
    
    /// 文字列をカンマ書式に変更して返却
    ///
    /// - Parameters:
    ///   - minimumDigits: 指定した数字最小でで小数点以下の桁数を指定
    ///   - maximumDigits: 指定した数字最大で小数点以下の桁数を指定
    /// - Returns: カンマ書式の数値文字列。変換できないときは`nil`を返す
    func comma(minimumDigits: Int? = nil,
               maximumDigits: Int? = nil,
               isSymbol: Bool = false) -> String? {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        if let minimumDigits = minimumDigits {
            formatter.minimumFractionDigits = minimumDigits
        }
        if let maximumDigits = maximumDigits {
            formatter.maximumFractionDigits = maximumDigits
        }
        
        if isSymbol {
            var tmp = self.replacingOccurrences(of: " ", with: "")
            var symbol = ""
            if tmp.contains("+") {
                symbol = "+"
                tmp = tmp.replacingOccurrences(of: "+", with: "")
            } else {
                symbol = "-"
                tmp = tmp.replacingOccurrences(of: "-", with: "")
            }
            
            guard let value = Double(tmp) else { return nil }
            guard let result = formatter.string(from: NSNumber(value: value)) else {
                return nil
            }
            return symbol + result
        } else {
            
            guard let value = Double(self) else { return nil }
            guard let result = formatter.string(from: NSNumber(value: value)) else {
                return nil
            }
            return result
        }
    }
    
    func emptyDefault(emptyReplaceText: String = "-") -> String {
        return self.isEmpty ? emptyReplaceText : self
    }
    
    // MARK: - Verge Address Validation
    
    var addressLengthValidation: Bool {
        let vergeAdressByte = 34
        return self.count == vergeAdressByte
    }
    
    var addressFormatValidation: Bool {
        if self.range(of: "^[A-Z0-9a-z]+$", options: .regularExpression) == nil {
            return false
        }
        return true
    }
    
    var removeVergeString: String {
        return self.replacingOccurrences(of: "verge:", with: "")
    }
    
    var localized: String {
        let key = UserDefaults.key.currentLanguage.rawValue
        let lang = UserDefaults.standard.string(forKey: key)
        
        if let path = Bundle.main.path(forResource: lang, ofType: "lproj"),
            let bundle = Bundle(path: path) {
        
            return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
        }
        return self
    }
}
