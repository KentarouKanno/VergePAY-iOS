//
//  TransactionCell.swift
//  
//
//  Created by Kentarou on 2018/01/28.
//

import UIKit

class TransactionCell: UITableViewCell {
    
    var tapTX: ((String) -> Void)?
    
    @IBOutlet weak var timeStampLabel: NotificationUpdateLabel!
    @IBOutlet weak var paymentTypeLabel: NotificationUpdateLabel!
    @IBOutlet weak var amountLabel: NotificationUpdateLabel!
    
    @IBOutlet weak var bottomGrayLine: UIView!
    @IBOutlet weak var bottomBlueLine: UIView!
    
    @IBOutlet weak var transactionHashLabel: LinkLabel!
    var history: TransactionHistory? {
        didSet {
            
            if let history = history {
                timeStampLabel.text = history.timestamp
                switch history.paymentType {
                case .payment(let text, let color):
                    
                    paymentTypeLabel.localizeText = text
                    paymentTypeLabel.textColor = color
                case .withdrawal(let text, let color):
                    
                    paymentTypeLabel.localizeText = text
                    paymentTypeLabel.textColor = color
                }
                
                amountLabel.text = history.amount.comma(minimumDigits: 3,
                                                        maximumDigits: 8,
                                                        isSymbol: true)
                
                transactionHashLabel.linkText = history.transactionHash
                transactionHashLabel.type = .normal
                
            }
        }
    }
    
    @IBAction func linkTouchDown(_ sender: UIButton) {
        transactionHashLabel.type = .selected
    }
    
    @IBAction func touchUpOutside(_ sender: UIButton) {
        transactionHashLabel.type = .normal
    }
    
    @IBAction func tapTransaction(_ sender: UIButton) {
        transactionHashLabel.type = .normal
        if let tx = history?.transactionHash,
            let urlString = Bundle.url(key: .tx) {
            tapTX?(urlString + tx)
        }
    }
    
    func setBottomLine(isLastCell: Bool) {
        bottomGrayLine.isHidden = isLastCell ? true : false
        bottomBlueLine.isHidden = isLastCell ? false : true
    }
}

