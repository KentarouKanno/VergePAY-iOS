//
//  QRDisplayCell.swift
//
//
//  Created by Kentarou on 2018/01/27.
//

import UIKit

class QRDisplayCell: UITableViewCell,
                     UITextFieldDelegate {
    
    var setTextField: ((UITextField) -> Void)?
    
    private let qrHeight = 170
    private let qrPlaceholderImage = UIImage(named: "QRPlaceholder")
    private let defaultText = "送金 XVG : "
    
    var vergeJPY: Double = 0
    
    var qrText: String {
        // verge:DAFBig1fpxkr8TzMNr854ddpEGK3QACaPx?amount=9.685656
        return "verge:\(addressStr ?? "")?amount=\(amount ?? "")"
    }
    var address: String? {
        didSet {
            if let address = address {
                addressStr = address
                amountTextField.isEnabled = address.isEmpty ? false : true
            }
        }
    }
    
    private var addressStr: String?
    private var amount: String?
    
    // QR ImageView
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var sendPriceLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField! {
        didSet {
            amountTextField.delegate = self
        }
    }
    
    private func createQR(amount: String? = nil) {
        
        if let amount = amount {
            self.amount = amount
        }
        
        print(qrText)
        
        // 文字列からQR画像を生成
        if let data = qrText.data(using: .utf8),
            let qrImage = UIImage.qrCode(data: data, color: .black) {
            qrImageView.image = qrImage.resize(CGSize(width: qrHeight, height: qrHeight))
        }
    }
    
    @IBAction func editingChange(_ sender: UITextField) {
        amount = sender.text
        
        if let amount = amount, amount.isEmpty {
            sendPriceLabel.text = defaultText
            qrImageView.image = qrPlaceholderImage
            return
        }
        
        if let _ = addressStr, let amount = amount {
            
            if let amount = Double(amount), let value = (amount / vergeJPY).comma(maximumDigits: 6) {
                sendPriceLabel.text = defaultText + value
            }
            createQR(amount: amount)
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        setTextField?(amountTextField)
        return true
    }
}

