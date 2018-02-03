//
//  GetMarketPriceAPIModel.swift
//  QRScan
//
//  Created by Kentarou on 2018/01/29.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import Foundation


class MarketPriceAPIModel {
    
    static var binanceTask: URLSessionDataTask?
    static var bittrexTask: URLSessionDataTask?
    
    class func getMarketPrice_Binance(completionHandler: @escaping (VergePrice?) -> Void) {
        
        if let url = URL(string: "https://api.binance.com/api/v3/ticker/price?symbol=XVGBTC") {
            
            let request = URLRequest(url: url)
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            binanceTask?.cancel()
            
            binanceTask = session.dataTask(with: request) { data, response, error in
                
                if let _ = response, let data = data {
                    
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data) as? [String: String],
                            let price = json["price"]  {
                            
                            print("Binance:", price)
                            completionHandler(VergePrice(btc_verge: price))
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
            
            binanceTask?.resume()
        }
    }
    
    
    class func getMarketPrice_Bittrex(completionHandler: @escaping (VergePrice?) -> Void) {
        
        if let url = URL(string: "https://bittrex.com/api/v1.1/public/getticker?market=BTC-XVG") {
            
            let request = URLRequest(url: url)
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            bittrexTask?.cancel()
            
            bittrexTask = session.dataTask(with: request) { data, response, error in
                
                if let _ = response, let data = data {
                    
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                            let result = json["result"] as? [String: Float],
                            let price = result["Last"] {
                            
                            print("Bittrex:", String(format: "%.8f", price))
                            completionHandler(VergePrice(btc_verge: String(format: "%.8f", price)))
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
            
            bittrexTask?.resume()
        }
    }
}
