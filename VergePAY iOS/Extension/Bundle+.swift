//
//  Bundle+.swift
//  VergePAY iOS
//
//  Created by Kentarou on 2018/02/09.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import Foundation

extension Bundle {
    enum UrlKey: String {
        case bainance = "BinanceURL"
        case bittrex = "BittrexURL"
        case rate = "ConvertPriceURL"
        case address = "BlockInfoAddressURL"
        case tx = "BlockInfoTxURL"
    }
    
    class func url(key: UrlKey) -> String? {
        let inputKey = key.rawValue
        guard let urlDictionary = Bundle.main.infoDictionary?["URLs"] as? Dictionary<String, Any> else { return nil }
        guard let urlString = urlDictionary[inputKey] as? String else { return nil }
        return  urlString
    }
}
