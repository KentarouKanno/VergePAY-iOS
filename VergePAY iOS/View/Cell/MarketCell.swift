//
//  MarketCell.swift
//  QRScan
//
//  Created by Kentarou on 2018/01/30.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import UIKit

class MarketCell: UITableViewCell {

    @IBOutlet weak var binancePriceLabel: UILabel!
    @IBOutlet weak var bittrexPriceLabel: UILabel!
    @IBOutlet weak var jpyPriceLabel: UILabel!
    
    func updateMarketPrice(marketPrice: MarketPrice, isAnimation: Bool = true) {
        
        let binancePrice = marketPrice.binancePrice
        binancePriceLabel.text = binancePrice.isEmpty ? "-" : binancePrice
        
        let bittrexPrice = marketPrice.bittrexPrice
        bittrexPriceLabel.text = bittrexPrice.isEmpty ? "-" : bittrexPrice
        
        jpyPriceLabel.text = marketPrice.vergeJPY.isEmpty ? "-" : marketPrice.vergeJPY
        
        if isAnimation {
            
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
