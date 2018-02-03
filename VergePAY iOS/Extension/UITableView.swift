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
    
    static let tableAnimationDuration = 0.3
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
    }
    
    func reloadData(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() })
        { _ in completion() }
    }
    
    func insertRows(at: [IndexPath], animation: UITableViewRowAnimation = .fade, completion: @escaping ()->()) {
        UIView.animate(withDuration: UITableView.tableAnimationDuration, animations: {
            self.insertRows(at: at, with: animation)
        }) { _ in
            completion()
            
        }
    }
    
    func deleteRows(at: [IndexPath], animation: UITableViewRowAnimation = .fade, completion: @escaping ()->()) {
        UIView.animate(withDuration: UITableView.tableAnimationDuration, animations: {
            self.deleteRows(at: at, with: animation)
        }) { _ in
            completion()
            
        }
    }
}
