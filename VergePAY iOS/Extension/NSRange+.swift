//
//  NSRange+.swift
//  QRScan
//
//  Created by Kentarou on 2018/02/02.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import Foundation
import UIKit

extension NSRange {
    static func allRenge(str: String) -> NSRange {
        return NSRange(location: 0,
                       length: str.count)
    }
}
