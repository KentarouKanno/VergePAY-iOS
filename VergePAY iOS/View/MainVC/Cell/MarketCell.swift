//
//  MarketCell.swift
//  QRScan
//
//  Created by Kentarou on 2018/01/30.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import UIKit

class MarketCell: UITableViewCell {
    
    @IBOutlet weak var heartImageView: NotificationUpdateImageView! {
        didSet {
            heartImageView.darkImage = R.image.darkHeart()
            heartImageView.lightImage = R.image.lightHeart()
            heartImageView.update()
        }
    }
    @IBOutlet weak var binancePriceLabel: NotificationUpdateLabel!
    @IBOutlet weak var bittrexPriceLabel: NotificationUpdateLabel!
    @IBOutlet weak var priceLabel: NotificationUpdateLabel!
    @IBOutlet weak var currencyCodeLabel: NotificationUpdateLabel! {
        didSet {
            currencyCodeLabel.notificationLabelType = .currencyCodeColonLabel
            currencyCodeLabel.update()
        }
    }
    
    func updateMarketPrice(marketPrice: MarketPrice,
                           isAnimation: Bool = true) {
        
        let binancePrice = marketPrice.binancePrice
        binancePriceLabel.text = binancePrice.emptyDefault()
        
        let bittrexPrice = marketPrice.bittrexPrice
        bittrexPriceLabel.text = bittrexPrice.emptyDefault()
        
        priceLabel.text = marketPrice.vergeRate.emptyDefault()
        
        if isAnimation {
            heartImageView.flash()
            
            switch marketPrice.binanceStatus {
            case .none: break
            case .plus: binancePriceLabel.plusFlash()
            case .minus: binancePriceLabel.minusFlash()
            }
            
            switch marketPrice.bittrexStatus {
            case .none: break
            case .plus: bittrexPriceLabel.plusFlash()
            case .minus: bittrexPriceLabel.minusFlash()
            }
        }
    }
}
