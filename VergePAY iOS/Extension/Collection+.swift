//
//  Collection+.swift
//  QRScan
//
//  Created by Kentarou on 2018/01/29.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import Foundation


extension Collection where Indices.Iterator.Element == Index {
    
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Iterator.Element? {
        return startIndex..<endIndex ~= index ? self[index] : nil
    }
}
