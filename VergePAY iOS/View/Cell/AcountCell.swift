//
//  AcountCell.swift
//  QRScan
//
//  Created by Kentarou on 2018/01/28.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import UIKit

class AcountCell: UITableViewCell {
    
    var tapAddress: ((String) -> Void)?
    
    @IBOutlet weak var addressLabel: LinkLabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var legalTenderLabel: UILabel!
    
    var blockInfoAddress: BlockInfo_Address? {
        didSet {
            if let blockInfoAddress = blockInfoAddress {
                
                addressLabel.normalText = "Address : "
                addressLabel.linkText = blockInfoAddress.address
                addressLabel.type = .normal
                
                balanceLabel.text = "Balance : " + blockInfoAddress.balanceText
            }
        }
    }
    
    func updateAmount(accountAmount: String) {
        legalTenderLabel.text = "日本円：" + accountAmount
    }
    
    @IBAction func linkTouchDown(_ sender: UIButton) {
        addressLabel.type = .selected
    }
    
    @IBAction func touchUpOutside(_ sender: UIButton) {
        addressLabel.type = .normal
    }
    
    @IBAction func tapAddress(_ sender: UIButton) {
        addressLabel.type = .normal
        if let address = blockInfoAddress?.address {
            tapAddress?(BlockInfoURL.address.rawValue + address)
        }
    }
}
