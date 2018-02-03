//
//  MainViewModel.swift
//  QRScan
//
//  Created by Kentarou on 2018/01/28.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import Foundation
import UIKit

class MainViewModel {
    
    private let decimalPlace = "%.6f"
    
    var marketPriceUpdate: ((MarketPrice) -> Void)?
    
    private var binancePrice: String?
    private var bittrexPrice: String?
    
    var marketPrice = MarketPrice()
    
    var currencyRate: Double?
    var vergeRate: Double?
    var marketTimer: Timer?
    var rateTimer: Timer?
    
    private var isRequestMarket = false
    private var isRequestRate   = false
    
    let marketTimerInterval: TimeInterval = 5.0
    var rateTimerInterval: TimeInterval = 5.0
    
    var address: String?
    var blockInfoAddress: BlockInfo_Address?
    var countryConvertData: CountryConvertData?
    
    var accountAmount: String {
        if let currencyPrice = vergeRate,
            let balanceStr = blockInfoAddress?.balance,
            let balance = Double(balanceStr) {
            if let value = (currencyPrice * balance).comma(maximumDigits: 6) {
                return value
            }
        }
        return "-"
    }
    
    init() {
        startMarketTimer()
        startRateTimer()
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self,
                                       selector: #selector(self.didEnterBackground(notification:)),
                                       name: .UIApplicationDidEnterBackground,
                                       object: nil)
        
        notificationCenter.addObserver(self,
                                       selector: #selector(self.willEnterForeground(notification:)),
                                       name: .UIApplicationWillEnterForeground,
                                       object: nil)
        
        notificationCenter.addObserver(self,
                                       selector: #selector(self.rateCal),
                                       name: .rateChangeNotification,
                                       object: nil)
    }
    
    @objc func didEnterBackground(notification: Notification) {
        rateTimer?.invalidate()
        marketTimer?.invalidate()
        
        if let topVC = UIApplication.shared.topViewController {
            if let alertController = topVC as? UIAlertController {
                alertController.dismiss(animated: false, completion: nil)
                
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    appDelegate.showSplash()
                }
            }
        }
    }
    
    @objc func willEnterForeground(notification: Notification) {
        
        if let validTimer = rateTimer?.isValid, !validTimer {
            rateTimerInterval = 5.0
            startRateTimer()
        }
        
        if let validTimer = marketTimer?.isValid, !validTimer {
            startMarketTimer()
        }
    }
    
    func startRateTimer(isFire: Bool = true) {
        
        rateTimer = Timer.scheduledTimer(timeInterval: rateTimerInterval,
                                           target: self,
                                           selector: #selector(self.updateConvertRate),
                                           userInfo: nil,
                                           repeats: true)
        if isFire {
            rateTimer?.fire()
        }
    }
    
    func startMarketTimer() {
        
        marketTimer = Timer.scheduledTimer(timeInterval: marketTimerInterval,
                                     target: self,
                                     selector: #selector(self.updateMarketPrice),
                                     userInfo: nil,
                                     repeats: true)
        marketTimer?.fire()
    }
    
    @objc func updateConvertRate() {
        
        if isRequestRate { return }
        isRequestRate = true
        
        BTCConvertPriceAPIModel.getBTCConvertPrice { (result) in
            
            if let result = result {
                self.countryConvertData = result
                self.rateCal(log: true)
            }
            
            self.isRequestRate = false
            if let _ = self.vergeRate {
                self.rateTimerInterval = 60 * 5
            } else {
                self.rateTimerInterval = 5.0
            }
            
            DispatchQueue.mainSyncSafe {
                self.rateTimer?.invalidate()
                self.startRateTimer(isFire: false)
            }
        }
    }
    
    @objc func rateCal(log: Bool = false) {
        
        let currentCode = UserDefaults.standard.getStringValue(key: .currency)
        
        if let convertData = self.countryConvertData {
            if let currencyData = convertData.data.filter({ $0.code == currentCode }).first {
                self.currencyRate = currencyData.calcRate
                
                if let currencyRate = self.currencyRate,
                    let binancePrice = self.binancePrice,
                    let vergeRate = Double(binancePrice) {
                    
                    self.vergeRate = currencyRate * vergeRate
                    
                    if let vergeRate = self.vergeRate {
                        if log {
                            print("Verge Rate =", self.marketPrice.vergeRate)
                        }
                        self.marketPrice.vergeRate = String(format: self.decimalPlace, vergeRate)
                    }
                }
            }
        }
    }
    
    @objc func updateMarketPrice() {
        
        if isRequestMarket { return }
        isRequestMarket = true
        
        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "PriceGetQueue", attributes: .concurrent)
        
        dispatchGroup.enter()
        var isError = false
        
        dispatchQueue.async(group: dispatchGroup) {
            // Binance price
            MarketPriceAPIModel.getMarketPrice_Binance { (result) in
                if let result = result {
                    self.binancePrice = result.btc_verge
                    self.marketPrice.setPrice(newBinancePrice: result.btc_verge)
                } else {
                    isError = true
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.enter()
        
        dispatchQueue.async(group: dispatchGroup) {
            // Bittrex price
            MarketPriceAPIModel.getMarketPrice_Bittrex { (result) in
                if let result = result {
                    self.bittrexPrice = result.btc_verge
                    self.marketPrice.setPrice(newBittrexPrice: result.btc_verge)
                } else {
                    isError = true
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            
            self.isRequestMarket = false
            if isError { return }
            
            self.rateCal()
            self.marketPriceUpdate?(self.marketPrice)
        }
    }
}
