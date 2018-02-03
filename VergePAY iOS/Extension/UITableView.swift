//
//  UITableView.swift
//  QRScan
//
//  Created by Kentarou on 2018/01/28.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import Foundation
import UIKit


extension UITableView {
    func reloadData(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() })
        { _ in completion() }
    }
    
    func insertRows(at: [IndexPath], completion: @escaping ()->()) {
        UIView.animate(withDuration: 0.3, animations: {
            self.insertRows(at: at, with: .automatic)
        }) { _ in
            completion()
            
        }
    }
}
