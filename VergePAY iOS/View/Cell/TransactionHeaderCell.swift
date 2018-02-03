//
//  TransactionHeaderCell.swift
//  QRScan
//
//  Created by Kentarou on 2018/01/28.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import UIKit

class TransactionHeaderCell: UITableViewCell {

    @IBOutlet weak var headerBaseView: UIView!
    
    var blockInfoAddress: BlockInfo_Address? {
        didSet {
            if let blockInfoAddress = blockInfoAddress {
                
                headerBaseView.isHidden = blockInfoAddress.history.isEmpty ? true : false
            }
        }
    }
}
