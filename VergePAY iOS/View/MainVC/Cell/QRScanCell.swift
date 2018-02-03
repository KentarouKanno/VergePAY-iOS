//
//  QRScanCell.swift
//  QRScan
//
//  Created by Kentarou on 2018/01/27.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import UIKit

class QRScanCell: UITableViewCell,
                  UITextFieldDelegate {
    
    var setTargetTextField: (() -> Void)?
    var toScanVC: (() -> Void)?
    var toAddressSearch: ((String) -> Void)?
    var rootViewController: UIViewController?

    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var addressTextField: NotificationUpdateTextField! {
        didSet {
            addressTextField.delegate = self
        }
    }
    
    @IBAction func rqScan(_ sender: UIButton) {
        toScanVC?()
    }
    
    @IBAction func enter(_ sender: UIButton) {
        if let text = addressTextField.text {
            toAddressSearch?(text)
        }
    }
    
    @IBAction func editingChange(_ sender: UITextField) {
        if let text = sender.text {
            
            if !text.addressFormatValidation {
                enterButton.isEnabled = false
                return
            }
            enterButton.isEnabled = text.isEmpty ? false : true
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        setTargetTextField?()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let text = textField.text, text.addressLengthValidation {
            toAddressSearch?(text)
        }
        textField.resignFirstResponder()
        return true
    }
}
