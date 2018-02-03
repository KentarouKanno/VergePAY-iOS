//
//  MainViewModel.swift
//  QRScan
//
//  Created by Kentarou on 2018/01/28.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import Foundation

class MainViewModel {
    
    var marketPriceUpdate: ((MarketPrice) -> Void)?
    
    private var binancePrice: String?
    private var bittrexPrice: String?
    
    var marketPrice = MarketPrice()
    
    var jpyRate: Double?
    var vergeJPY: Double?
    
    var accountAmount: String {
        if let jpyPrice = vergeJPY,
            let balanceStr = blockInfoAddress?.balance,
            let balance = Double(balanceStr) {
            if let value = (jpyPrice * balance).comma(maximumDigits: 6) {
                return value
            }
        }
        return "-"
    }
    
    var timer: Timer?
    
    var address: String?
    var blockInfoAddress: BlockInfo_Address?
    
    init() {
        startTimer()
        
        BTCConvertPriceAPIModel.getBTCConvertPrice { (result) in
            
            if let result = result {
                if let jpyData = result.data.filter({ $0.code == "JPY" }).first {
                    self.jpyRate = jpyData.calcRate
                }
            }
        }
    }
    
    func startTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 5.0,
                                     target: self,
                                     selector: #selector(self.updateMarketPrice),
                                     userInfo: nil,
                                     repeats: true)
        timer?.fire()
    }
    
    @objc func updateMarketPrice() {
        
        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "PriceGetQueue", attributes: .concurrent)
        
        dispatchGroup.enter()
        
        dispatchQueue.async(group: dispatchGroup) {
            // Binance価格
            MarketPriceAPIModel.getMarketPrice_Binance { (result) in
                if let result = result {
                    self.binancePrice = result.btc_verge
                    if let jpyRate = self.jpyRate,
                        let binancePrice = self.binancePrice,
                        let vergeRate = Double(binancePrice) {
                        
                        self.vergeJPY = jpyRate * vergeRate
                        if let vergeJPY = self.vergeJPY {
                            self.marketPrice.vergeJPY = String(format: "%.8f", vergeJPY)
                        }
                        self.marketPrice.setPrice(newBinancePrice: binancePrice)
                        dispatchGroup.leave()
                    }
                }
            }
        }
        
        dispatchGroup.enter()
        
        dispatchQueue.async(group: dispatchGroup) {
            // Bittrex価格
            MarketPriceAPIModel.getMarketPrice_Bittrex { (result) in
                if let result = result {
                    self.bittrexPrice = result.btc_verge
                    self.marketPrice.setPrice(newBittrexPrice: result.btc_verge)
                }
                dispatchGroup.leave()
            }
        }
        
        // 全ての非同期処理完了後にメインスレッドで処理
        dispatchGroup.notify(queue: .main) {
            self.marketPriceUpdate?(self.marketPrice)
        }
    }
}
