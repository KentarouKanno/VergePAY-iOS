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
        return amount.contains("+") ? .payment("入金", #colorLiteral(red: 0.0008818559581, green: 0.7212129746, blue: 0.003402970498, alpha: 1)) : .withdrawal("出金", #colorLiteral(red: 0.9912289977, green: 0.199350208, blue: 0.2284550965, alpha: 1))
    }
    var timestamp_store: String = ""
    var transactionHash: String = ""
    var amount: String = ""
    
    func description() {
        print("Timestamp - " + timestamp + ", Hash - " + transactionHash + ", Amount - " + amount)
    }
}

