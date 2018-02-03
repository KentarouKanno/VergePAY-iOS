//
//  CalculateCell.swift
//  VergePAY iOS
//
//  Created by Kentarou on 2018/03/12.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import UIKit

class CalculateCell: UITableViewCell, UITextFieldDelegate {
    
    var vergeRate: Double? {
        didSet {
            if let vergeRate = vergeRate {
                rate = vergeRate
                editinChange(textField)
            }
        }
    }
    var rate: Double?
    
    @IBOutlet weak var calculateLabel: NotificationUpdateLabel! 
    @IBOutlet weak var textField: NotificationUpdateTextField! {
        didSet {
            textField.delegate = self
        }
    }
    @IBOutlet weak var currencyCodeLabel: NotificationUpdateLabel! {
        didSet {
            currencyCodeLabel.notificationLabelType = .currencyCodeLabel
            currencyCodeLabel.update()
        }
    }

    @IBAction func editinChange(_ sender: NotificationUpdateTextField) {
        
        if let rate = rate,
            let text = textField.text {
            
            guard let amount = Double(text)  else {
                calculateLabel.text = "0"
                return
            }
            
            calculateLabel.text = String(amount * rate)
        }
    }
}
