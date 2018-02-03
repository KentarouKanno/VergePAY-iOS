//
//  DateFormatter+.swift
//  QRScan
//
//  Created by Kentarou on 2018/01/28.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    class func convertDateFormat(dateStr: String,
                                 beforeformat: String = "dd MM yyyy HH:mm:ss",
                                 afterformat: String = "yyyy/MM/dd HH:mm:ss") -> String {
        
        // "2 Dec 2017 08:31:03" → 2017/12/02 08:31:03
        
        // String → Date
        let inFormatter = DateFormatter()
        inFormatter.locale = Locale(identifier: "en_US")
        inFormatter.dateFormat = beforeformat
        
        if let date = inFormatter.date(from: dateStr) {
            // Date → String
            let outFormatter = DateFormatter()
            outFormatter.dateFormat = afterformat
            
            return outFormatter.string(from: date)
        }
        return ""
    }
}
