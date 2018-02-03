//
//  BTCConvertData.swift
//  QRScan
//
//  Created by Kentarou on 2018/01/30.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import Foundation


class BTCConvertData {
    
    var code: String = ""
    var name: String = ""
    var rate: String = ""
    
    var calcRate: Double? {
        return Double(rate)
    }
    
    init(dict: [String: Any]) {
        
        if let code = dict["code"] as? String {
            self.code = code
        }
        if let name = dict["name"] as? String {
            self.name = name
        }
        if let rate = dict["rate"] as? Double {
            self.rate = String(format: "%.6f", rate)
        }
    }
}

class CountryConvertData {
    
    var data: [BTCConvertData] = []
    
    init() {
        
    }
    
    init(arrayJson: [[String: Any]]) {
        
        for item in arrayJson {
            data.append(BTCConvertData(dict: item))
        }
    }
    let removeCurrency = ["BTC", "BCH", "XAU", "XAG"]
    
    var CurrencyList: [String] {
        if data.isEmpty {
            return ["AED", "AFN", "ALL", "AMD", "ANG", "AOA", "ARS", "AUD", "AWG", "AZN", "BAM", "BBD", "BDT", "BGN", "BHD", "BIF", "BMD", "BND", "BOB", "BRL", "BSD", "BTN", "BWP", "BZD", "CAD", "CDF", "CHF", "CLF", "CLP", "CNY", "COP", "CRC", "CUP", "CVE", "CZK", "DJF", "DKK", "DOP", "DZD", "EGP", "ETB", "EUR", "FJD", "FKP", "GBP", "GEL", "GHS", "GIP", "GMD", "GNF", "GTQ", "GYD", "HKD", "HNL", "HRK", "HTG", "HUF", "IDR", "ILS", "INR", "IQD", "IRR", "ISK", "JEP", "JMD", "JOD", "JPY", "KES", "KGS", "KHR", "KMF", "KPW", "KRW", "KWD", "KYD", "KZT", "LAK", "LBP", "LKR", "LRD", "LSL", "LYD", "MAD", "MDL", "MGA", "MKD", "MMK", "MNT", "MOP", "MRO", "MUR", "MVR", "MWK", "MXN", "MYR", "MZN", "NAD", "NGN", "NIO", "NOK", "NPR", "NZD", "OMR", "PAB", "PEN", "PGK", "PHP", "PKR", "PLN", "PYG", "QAR", "RON", "RSD", "RUB", "RWF", "SAR", "SBD", "SCR", "SDG", "SEK", "SGD", "SHP", "SLL", "SOS", "SRD", "STD", "SVC", "SYP", "SZL", "THB", "TJS", "TMT", "TND", "TOP", "TRY", "TTD", "TWD", "TZS", "UAH", "UGX", "USD", "UYU", "UZS", "VEF", "VND", "VUV", "WST", "XAF", "XCD", "XOF", "XPF", "YER", "ZAR", "ZMW", "ZWL"]
        }
        
        return data.map { $0.code }.filter{ !removeCurrency.contains($0) }.sorted(by: { $0 < $1 })
    }
}
