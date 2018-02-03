//
//  CGContext+.swift
//  QRScan
//
//  Created by Kentarou on 2018/01/30.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import Foundation
import UIKit

extension CGContext {
    func addLineThrough(_ points: [(CGFloat, CGFloat)]) {
        guard let first = points.first else { return }
        move(to: CGPoint(x: first.0, y: first.1))
        points.dropFirst().forEach {
            addLine(to: CGPoint(x: $0.0, y: $0.1))
        }
    }
}
