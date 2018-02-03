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
    @IBOutlet weak var currencyCodeLabel: NotificationUpdateLabel! {
        didSet {
            currencyCodeLabel.notificationLabelType = .currencyCodeColonLabel
            currencyCodeLabel.update()
        }
    }
    @IBOutlet weak var legalTenderLabel: UILabel!
    @IBOutlet weak var copyButton: NotificationUpdateButton! {
        didSet {
            copyButton.lightImage = R.image.copyLight()
            copyButton.darkImage = R.image.copyDark()
            copyButton.update()
        }
    }
    
    var blockInfoAddress: BlockInfo_Address? {
        didSet {
            if let blockInfoAddress = blockInfoAddress {
                
                addressLabel.normalText = "Address : "
                addressLabel.linkText = blockInfoAddress.address
                addressLabel.type = .normal
                
                balanceLabel.text = "Balance : " + blockInfoAddress.balanceText
                currencyCodeLabel.update()
            }
        }
    }
    
    func updateAmount(accountAmount: String) {
        legalTenderLabel.text = accountAmount
    }
    
    @IBAction func linkTouchDown(_ sender: UIButton) {
        addressLabel.type = .selected
    }
    
    @IBAction func touchUpOutside(_ sender: UIButton) {
        addressLabel.type = .normal
    }
    
    @IBAction func tapAddress(_ sender: UIButton) {
        addressLabel.type = .normal
        if let address = blockInfoAddress?.address,
            let urlString = Bundle.url(key: .address) {
            tapAddress?(urlString + address)
        }
    }
    
    // Copy
    @IBAction func tapCopy(_ sender: UIButton) {
        if let address = blockInfoAddress?.address {
            let pasteboard = UIPasteboard.general
            pasteboard.string = address
            UIAlertController.toast(message: LocalizedKey.addressCopy.rawValue.localized)
            
            if #available(iOS 10.0, *) {
                let generator = UISelectionFeedbackGenerator()
                generator.prepare()
                generator.selectionChanged()
            } else {
                // Fallback on earlier versions
            }
        }
    }
}
