//
//  GetBTCConvertPrice.swift
//  QRScan
//
//  Created by Kentarou on 2018/01/30.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import Foundation

// https://bitpay.com/api/rates

class BTCConvertPriceAPIModel {
    
    static var requestTask: URLSessionDataTask?
    
    class func getBTCConvertPrice(completionHandler: @escaping (CountryConvertData?) -> Void) {
        
        if let urlString = Bundle.url(key: .rate),
            let url = URL(string: urlString) {
            
            let request = URLRequest(url: url)
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            requestTask?.cancel()
            
            requestTask = session.dataTask(with: request) { data, response, error in
                
                if let _ = response, let data = data {
                    
                    do {
                        if let arrayJson = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                            let data = CountryConvertData(arrayJson: arrayJson)
                            
                            completionHandler(data)
                            return
                        }
                    } catch let parseError {
                        print("parsing error: \(parseError)")
                        let responseString = String(data: data, encoding: .utf8)
                        print("raw response: \(responseString ?? "")")
                        
                        completionHandler(nil)
                    }
                    
                } else {
                    completionHandler(nil)
                }
            }
            
            requestTask?.resume()
        }
    }
}
