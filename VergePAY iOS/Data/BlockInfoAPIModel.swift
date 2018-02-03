//
//  BlockInfoAPIModel.swift
//  QRScan
//
//  Created by Kentarou on 2018/01/24.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import Foundation
import Kanna

class BlockInfoAPIModel {
    
    static var isRequest = false
    
    class func getAdressInfo(address :String, completionHandler: @escaping (BlockInfo_Address?) -> Void) {
        
        if isRequest { return }
        isRequest = true
        
        if let url = URL(string: "https://verge-blockchain.info/address/" + address) {
            
            let request = URLRequest(url: url)
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            let task = session.dataTask(with: request) { data, response, error in
                
                DispatchQueue.mainSyncSafe {
                    
                    isRequest = false
                    
                    if let _ = response, let data = data {
                        
                        let addressData = BlockInfoAddressParser.parser(data: data, address: address)
                        completionHandler(addressData)
                        
                    } else {
                        completionHandler(nil)
                    }
                }
            }
            
            task.resume()
        }
    }
}
