//
//  BTCConvertData.swift
//  QRScan
//
//  Created by Kentarou on 2018/01/30.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import Foundation


class BTCConvertData {
    
    var code: String = ""
    var name: String = ""
    var rate: String = ""
    
    var calcRate: Double? {
        return Double(rate)
    }
    
    init(dict: [String: Any]) {
        
        if let code = dict["code"] as? String {
            self.code = code
        }
        if let name = dict["name"] as? String {
            self.name = name
        }
        if let rate = dict["rate"] as? Double {
            self.rate = String(format: "%.6f", rate)
        }
    }
}

class CountryConvertData {
    
    var data: [BTCConvertData] = []
    
    init(arrayJson: [[String: Any]]) {
        
        for item in arrayJson {
            
            data.append(BTCConvertData(dict: item))
        }
    }
}
