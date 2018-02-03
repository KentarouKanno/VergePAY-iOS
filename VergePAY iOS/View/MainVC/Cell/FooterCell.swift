//
//  FooterCell.swift
//  QRScan
//
//  Created by Kentarou on 2018/01/30.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import UIKit

class FooterCell: UITableViewCell {
    
    @IBOutlet weak var baseView: NotificationUpdateView! {
        didSet {
            baseView.notificationViewType = .footerView
            baseView.update()
        }
    }
}
