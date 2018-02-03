//
//  QRDisplayCell.swift
//
//
//  Created by Kentarou on 2018/01/27.
//

import UIKit

class QRDisplayCell: UITableViewCell,
                     UITextFieldDelegate {
    
    var setTargetTextField: (() -> Void)?
    
    private let qrHeight = 170
    private let defaultTextKey = "Send XVG"
    private var price: String?
    
    var vergeRate: Double = 0
    
    var qrText: String {
        // verge:DAFBig1fpxkr8TzMNr854ddpEGK3QACaPx?amount=9.685656
        return "verge:\(addressStr ?? "")?amount=\(price ?? "")"
    }
    var address: String? {
        didSet {
            if let address = address {
                addressStr = address
                amountTextField.isEnabled = address.isEmpty ? false : true
                amountTextField.update()
            }
        }
    }
    
    private var addressStr: String?
    private var amount: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.update),
                                               name: .uiUpdateNotification,
                                               object: nil)
        update()
    }
    
    @objc func update() {
        editingChange(amountTextField)
    }
    
    // QR ImageView
    @IBOutlet weak var qrImageView: NotificationUpdateImageView!
    @IBOutlet weak var sendPriceLabel: NotificationUpdateLabel!
    @IBOutlet weak var amountTextField: ToolbarTextField! {
        didSet {
            amountTextField.delegate = self
        }
    }
    @IBOutlet weak var currencyCodeLabel: NotificationUpdateLabel! {
        didSet {
            currencyCodeLabel.notificationLabelType = .currencyCodeLabel
            currencyCodeLabel.update()
        }
    }
    
    private func createQR(amount: String? = nil) {
        
        if let amount = amount {
            self.amount = amount
        }
        
        print(qrText)
        
        // 文字列からQR画像を生成
        if let data = qrText.data(using: .utf8),
            let qrImage = UIImage.qrCode(data: data, color: CIColor(color: UIColor.black)) {
            qrImageView.image = qrImage.resize(CGSize(width: qrHeight, height: qrHeight))
        }
    }
    
    @IBAction func editingChange(_ sender: UITextField) {
        amount = sender.text
        
        if let amount = amount, amount.isEmpty {
            sendPriceLabel.text = defaultTextKey.localized
            qrImageView.imageViewType = .qrNoneImage
            qrImageView.update()
            return
        }
        
        qrImageView.imageViewType = .none
        if let _ = addressStr, let amount = amount {
            
            if let amount = Double(amount), let value = (amount / vergeRate).comma(maximumDigits: 6) {
                price = value
                sendPriceLabel.text = defaultTextKey.localized + value
            }
            createQR(amount: amount)
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        setTargetTextField?()
        return true
    }
}

