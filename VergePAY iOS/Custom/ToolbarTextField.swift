//
//  ToolbarTextField.swift
//  VergePAY iOS
//
//  Created by Kentarou on 2018/02/04.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import Foundation
import UIKit

protocol ToolbarTextFieldDelegate: class {
    func tapFinishButton(textField: ToolbarTextField,
                         text: String)
}

class ToolbarTextField: NotificationUpdateTextField {
    
    weak var toolbarTextFieldDelegate: ToolbarTextFieldDelegate?
    
    override var inputAccessoryView: UIView? {
        get {
            let toolBar = UIToolbar()
            toolBar.barStyle = .default
            toolBar.isTranslucent = true
            toolBar.tintColor = .black
            let doneButton = UIBarButtonItem(title: R.string.localizable.keyboardClose(),
                                             style: .done,
                                             target: self,
                                             action: #selector(self.tapFinishButton))
            
            let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                              target: nil,
                                              action: nil)
            
            toolBar.setItems([spaceButton, doneButton], animated: false)
            toolBar.isUserInteractionEnabled = true
            toolBar.sizeToFit()
            
            return toolBar
        }
        set {}
    }
    
    // MARK: - Private Method
    
    @objc func tapFinishButton() {
        if let text = self.text {
            toolbarTextFieldDelegate?.tapFinishButton(textField: self,
                                                     text: text)
        }
        self.resignFirstResponder()
    }
}
