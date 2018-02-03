//
//  BlockInfoAddressParser.swift
//  QRScan
//
//  Created by Kentarou on 2018/01/27.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import Foundation
import Kanna

class BlockInfoAddressParser {
    
    class func parser(data: Data, address: String) -> BlockInfo_Address? {
        
        if let html = String(data: data, encoding: .utf8) {
            
            let blockInfoAddress = BlockInfo_Address(address: address)
            
            if let doc = try? HTML(html: html, encoding: .utf8) {
                
                // Send - Received - Balance
                for link in doc.xpath("//*[@class='table table-bordered table-striped summary-table']//tbody//tr//td").enumerated() {
                    if let value = link.element.content  {
                        if link.offset == 0 {
                            // Total Sent
                            blockInfoAddress.totalSent = value
                        } else if link.offset == 1 {
                            // Total Received
                            blockInfoAddress.totalReceived = value
                        } else if link.offset == 2 {
                            // Balance
                            blockInfoAddress.balance = value
                        }
                    }
                }
                
                var transaction = TransactionHistory()
                
                for link in doc.xpath("//*[@class='table table-bordered table-striped history-table']//tbody//tr//td").enumerated() {
                    if let value = link.element.content  {
                        
                        let count = link.offset + 1
                        
                        if count % 3 == 1 {
                            // Timestamp
                            transaction.timestamp = value
                        } else if count % 3 == 2 {
                            // Hash
                            transaction.transactionHash = value
                        } else if count % 3 == 0 {
                            // Amount (XVG)
                            transaction.amount = value
                        }
                    }
                    
                    if !transaction.timestamp.isEmpty && !transaction.transactionHash.isEmpty && !transaction.amount.isEmpty {
                        blockInfoAddress.history.append(transaction)
                        transaction = TransactionHistory()
                    }
                }
                blockInfoAddress.description()
            }
            return blockInfoAddress
        }
        return nil
    }
}
