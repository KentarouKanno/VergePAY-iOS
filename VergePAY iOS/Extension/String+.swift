//
//  String+.swift
//  QRScan
//
//  Created by Kentarou on 2018/01/28.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import Foundation

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
    
    
    /// 文字列をカンマ書式に変更して返却します
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
    
    var addressValidation: Bool {
        if self.range(of: "^[A-Z0-9a-z]+$", options: .regularExpression) == nil {
            return false
        }
        return true
    }
}
