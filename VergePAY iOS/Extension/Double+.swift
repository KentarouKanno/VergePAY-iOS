//
//  Double+.swift
//  QRScan
//
//  Created by Kentarou on 2018/01/31.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import Foundation


extension Double {
    
    /// Double数値をカンマ書式に変更して返却します
    ///
    /// - Parameters:
    ///   - minimumDigits: 指定した数字最小でで小数点以下の桁数を指定
    ///   - maximumDigits: 指定した数字最大で小数点以下の桁数を指定
    /// - Returns: カンマ書式の数値文字列。変換できないときは`nil`を返す
    func comma(minimumDigits: Int? = nil,
               maximumDigits: Int? = nil) -> String? {
        
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
        guard let result = formatter.string(from: NSNumber(value: self)) else {
            return nil
        }
        return result
    }
}
