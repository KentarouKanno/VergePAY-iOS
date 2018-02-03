//
//  BlockInfoData.swift
//  QRScan
//
//  Created by Kentarou on 2018/01/27.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import Foundation
import UIKit

enum PaymentType {
    case payment(String, UIColor)
    case withdrawal(String, UIColor)
}

class VergePrice {
    var btc_verge: String = ""
    
    init(btc_verge: String) {
        self.btc_verge = btc_verge
    }
}

class BlockInfo_Address {
    
    var address: String = ""
    var balance: String = ""
    var totalSent: String = ""
    var totalReceived: String = ""
    var history: [TransactionHistory] = []
    
    init(address: String) {
        self.address = address
    }
    
    func description() {
        
        print("--- BlockInfo_Address class ---\n")
        print("Address =", address)
        print("Total Sent(XVG) =", totalSent)
        print("Total Received(XVG) =",totalReceived)
        print("Balance(XVG) =", balance)
        
        print("\n--- Transaction History ---\n")
        print("history.count =", history.count)
        history.forEach { $0.description() }
    }
    
    var balanceText: String {
        if let balance = self.balance.comma(minimumDigits: 3,
                                            maximumDigits: 8) {
            
            return balance
        }
        return "-"
    }
}

class TransactionHistory {
    
    var timestamp: String {
        get {
            return timestamp_store
        }
        set(newValue) {
            
            let dateStr = newValue.convertDateFormat()
            timestamp_store = DateFormatter.convertDateFormat(dateStr: dateStr)
        }
    }
    var paymentType: PaymentType {
        return amount.contains("+") ? .payment(LocalizedKey.paymentIn.rawValue, #colorLiteral(red: 0.004154716021, green: 0.8394529357, blue: 0.0161397376, alpha: 1)) : .withdrawal(LocalizedKey.paymentOut.rawValue, #colorLiteral(red: 0.9912289977, green: 0.3125081461, blue: 0.3057293181, alpha: 1))
    }
    var timestamp_store: String = ""
    var transactionHash: String = ""
    var amount: String = ""
    
    func description() {
        print("Timestamp - " + timestamp + ", Hash - " + transactionHash + ", Amount - " + amount)
    }
}

