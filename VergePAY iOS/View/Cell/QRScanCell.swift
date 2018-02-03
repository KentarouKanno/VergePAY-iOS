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
    
    var setTextField: ((UITextField) -> Void)?
    var toScanVC: (() -> Void)?
    var toAddressSearch: ((String) -> Void)?

    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var addressTextField: UITextField! {
        didSet {
            addressTextField.delegate = self
        }
    }
    
    @IBAction func rqScan(_ sender: UIButton) {
        if QRScanViewController.isCameraAllowed {
            toScanVC?()
        }
    }
    
    @IBAction func enter(_ sender: UIButton) {
        if let text = addressTextField.text {
            toAddressSearch?(text)
        }
    }
    
    @IBAction func editingChange(_ sender: UITextField) {
        if let text = sender.text {
            
            if !text.addressValidation {
                enterButton.isEnabled = false
                return
            }
            enterButton.isEnabled = text.isEmpty ? false : true
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        setTextField?(addressTextField)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
