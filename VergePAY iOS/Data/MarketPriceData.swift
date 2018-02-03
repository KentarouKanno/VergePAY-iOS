//
//  MarketPriceData.swift
//  QRScan
//
//  Created by Kentarou on 2018/02/03.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import Foundation

enum MarketStatus {
    case none
    case plus
    case minus
}

class MarketPrice {
    
    var binancePrice = ""
    var binanceStatus: MarketStatus = .none
    
    var bittrexPrice = ""
    var bittrexStatus: MarketStatus = .none
    
    var vergeJPY = ""
    
    func setPrice(newBinancePrice: String) {
        if binancePrice.isEmpty {
            
            binanceStatus = .none
            binancePrice = newBinancePrice
        } else if binancePrice == newBinancePrice {
            
            binanceStatus = .none
            binancePrice = newBinancePrice
        } else {
            if let oldPrice = Double(binancePrice),
                let newPrice = Double(newBinancePrice) {
                
                binanceStatus = newPrice > oldPrice ? .plus : .minus
                binancePrice = newBinancePrice
            }
        }
    }
    
    func setPrice(newBittrexPrice: String) {
        if bittrexPrice.isEmpty {
            
            bittrexStatus = .none
            bittrexPrice = newBittrexPrice
        } else if bittrexPrice == newBittrexPrice {
            
            bittrexStatus = .none
            bittrexPrice = newBittrexPrice
        } else {
            if let oldPrice = Double(bittrexPrice),
                let newPrice = Double(newBittrexPrice) {
                
                bittrexStatus = newPrice > oldPrice ? .plus : .minus
                bittrexPrice = newBittrexPrice
            }
        }
    }
}
