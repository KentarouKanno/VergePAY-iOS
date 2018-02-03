//
//  ViewController.swift
//  QRScan
//
//  Created by Kentarou on 2018/01/22.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import UIKit
import SVProgressHUD

class MainViewController: UIViewController {
    
    var action: [(() -> ())?] = []
    
    enum SectionType: Int, EnumEnumerable {
        case market
        case address
        case account
        case qr
        case history
        case footer
    }
    
    var targetTextField: UITextField?
    var isAccountCellOpen = false
    var isShowKeyboard  = false
    var isSendAction = false
    
    @IBOutlet weak var tableBottomConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: "MarketCell", bundle: nil), forCellReuseIdentifier: "MarketCell")
            tableView.register(UINib(nibName: "QRScanCell", bundle: nil), forCellReuseIdentifier: "QRScanCell")
            tableView.register(UINib(nibName: "AcountCell", bundle: nil), forCellReuseIdentifier: "AcountCell")
            tableView.register(UINib(nibName: "QRDisplayCell", bundle: nil), forCellReuseIdentifier: "QRDisplayCell")
            tableView.register(UINib(nibName: "TransactionHeaderCell", bundle: nil), forCellReuseIdentifier: "TransactionHeaderCell")
            tableView.register(UINib(nibName: "TransactionCell", bundle: nil), forCellReuseIdentifier: "TransactionCell")
            tableView.register(UINib(nibName: "FooterCell", bundle: nil), forCellReuseIdentifier: "FooterCell")
            tableView.tableFooterView = UIView()
        }
    }
    
    var mainViewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.368627451, green: 0.7960784314, blue: 0.9176470588, alpha: 1)
        addKeyboardNotification()
        
        mainViewModel.marketPriceUpdate = { marketPrice in
            if self.isShowKeyboard { return }
            for cell in self.tableView.visibleCells {
                if let cell = cell as? MarketCell {
                    DispatchQueue.mainSyncSafe {
                        cell.updateMarketPrice(marketPrice: marketPrice)
                    }
                }
            }
        }
    }
    
    func addKeyboardNotification() {
        
        // Set Notification
        let notificationCenter = NotificationCenter.default
        
        // キーボードが表示される直前の通知
        notificationCenter.addObserver(self,
                                       selector: #selector(self.willShowKeyboard(notification:)),
                                       name: NSNotification.Name.UIKeyboardWillShow,
                                       object: nil)
        
        // キーボードが表示された直後の通知
        notificationCenter.addObserver(self,
                                       selector: #selector(self.didShowKeyboard(notification:)),
                                       name: NSNotification.Name.UIKeyboardDidShow,
                                       object: nil)
        // キーボードが非表示になる直前の通知
        notificationCenter.addObserver(self,
                                       selector: #selector(self.willHideKeyboard(notification:)),
                                       name: NSNotification.Name.UIKeyboardWillHide,
                                       object: nil)
        
        // キーボードが非表示になった直後の通知
        notificationCenter.addObserver(self,
                                       selector: #selector(self.didHideKeyboard(notification:)),
                                       name: NSNotification.Name.UIKeyboardDidHide,
                                       object: nil)
        
        // キーボードの高さが変更された時の通知
        notificationCenter.addObserver(self,
                                       selector: #selector(self.willChangeKeyboard(notification:)),
                                       name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                       object: nil)
        
    }
    
    // WillShow Keyboad
    @objc func willShowKeyboard(notification: Notification) {
        
        guard !isShowKeyboard else {
            return
        }
        
        isShowKeyboard = true
        
        if let userInfo = (notification as NSNotification).userInfo {
            if let keyboard = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
                let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval {
                
                self.view.layoutIfNeeded()
                
                let keyBoardHeight = keyboard.cgRectValue.height
                self.tableBottomConstraints.constant = keyBoardHeight - UIApplication.shared.iPhoneXMargin
                
                UIView.animate(withDuration: duration, animations: {
                    self.view.layoutIfNeeded()
                }, completion: { (finished) in
                    
                })
            }
        }
    }
    
    // DidShow Keyboad
    @objc func didShowKeyboard(notification: Notification) {
        
        if let userInfo = (notification as NSNotification).userInfo {
            if let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval {
                
                UIView.animate(withDuration: duration, animations: {
                    
                }, completion: { (finished) in
                    if let textField = self.targetTextField,
                        textField.tag == 2 {
                        self.checkTableScroll()
                    }
                })
            }
        }
    }
    
    // WillChange Keyboad
    @objc func willChangeKeyboard(notification: Notification) {
        
        guard isShowKeyboard else {
            return
        }
        
        if let userInfo = (notification as NSNotification).userInfo {
            if let keyboard = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                
                let keyBoardHeight = keyboard.cgRectValue.height
                self.tableBottomConstraints.constant = keyBoardHeight - UIApplication.shared.iPhoneXMargin
            }
        }
    }
    
    // WillHide Keyboard
    @objc func willHideKeyboard(notification: Notification) {
        
        if let userInfo = (notification as NSNotification).userInfo {
            if let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval {
                
                self.tableBottomConstraints.constant = 0
                UIView.animate(withDuration:duration, animations: {
                    self.view.layoutIfNeeded()
                }, completion: { finish in
                    
                })
            }
        }
    }
    
    // DidHide Keyboard
    @objc func didHideKeyboard(notification: Notification) {
        
        isShowKeyboard = false
        
        if let userInfo = (notification as NSNotification).userInfo {
            if let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval {
                
                UIView.animate(withDuration:duration, animations: {
                    
                }, completion: { finish in
                    
                    if self.isSendAction {

                        // キーボードを下げた後に実行する
                        if let address = self.mainViewModel.address {
                            self.self.scanAddress(uri: address)
                        }
                        self.isSendAction = false
                    }
                })
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let navi = segue.destination as? UINavigationController,
            let qrScan = navi.viewControllers.first as? QRScanViewController {
            qrScan.completion = { uri in
                
                self.mainViewModel.address = uri
                self.tableView.reloadData()
                
                self.scanAddress(uri: uri)
            }
        }
        
        if let webView = segue.destination as? WebViewController,
            let urlString = sender as? String {
            webView.urlString = urlString
        }
    }
    
    func scanAddress(uri: String) {
        
        SVProgressHUD.show()
        
        BlockInfoAPIModel.getAdressInfo(address: uri) { result in
            
            SVProgressHUD.dismiss()
            
            if let result = result {
                self.mainViewModel.blockInfoAddress = result
                if self.tableView.numberOfRows(inSection: SectionType.account.hashValue) == 0 {
                    
                    self.tableView.insertRows(at: [IndexPath(row: 0,
                                                             section: SectionType.account.hashValue)]) {
                                                                self.isAccountCellOpen = true
                                                                
                                                                var indexArray: [IndexPath] = []
                                                                
                                                                if let count = self.mainViewModel.blockInfoAddress?.history.count {
                                                                    
                                                                    for num in 0...count {
                                                                        let index = IndexPath(row: num,
                                                                                              section: SectionType.history.hashValue)
                                                                        indexArray.append(index)
                                                                    }
                                                                    
                                                                    self.tableView.insertRows(at: indexArray) {
                                                                        
                                                                    }
                                                                }
                    }
                } else {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension MainViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionType.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = SectionType(rawValue: section) else { return 0 }
        switch sectionType {
        case .market: return 1
        case .address: return 1
        case .account: return mainViewModel.blockInfoAddress == nil ? 0 : 1
        case .qr: return 1
        case .history:
            if let historyCount = mainViewModel.blockInfoAddress?.history.count {
                return isAccountCellOpen ? 1 + historyCount : 0
            }
            return 0
        case .footer: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let sectionType = SectionType(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch sectionType {
        case .market:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "MarketCell",
                                                        for: indexPath) as? MarketCell {
                
                cell.updateMarketPrice(marketPrice: mainViewModel.marketPrice,
                                       isAnimation: true)
                return cell
            }
        case .address:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "QRScanCell",
                                                        for: indexPath) as? QRScanCell {
                cell.toScanVC  = {
                    self.performSegue(withIdentifier: "toQRScan", sender: nil)
                }
                cell.toAddressSearch = { uri in
                    
                    self.mainViewModel.address = uri
                    
                    if self.isShowKeyboard {
                        self.isSendAction = true
                        self.view.endEditing(true)
                    } else {
                        self.scanAddress(uri: uri)
                    }
                }
                
                cell.setTextField = { textField in
                    self.targetTextField = textField
                }
                return cell
            }
        case .account:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "AcountCell",
                                                        for: indexPath) as? AcountCell {
                
                cell.blockInfoAddress = mainViewModel.blockInfoAddress
                cell.updateAmount(accountAmount: mainViewModel.accountAmount)
                
                cell.tapAddress = { addressURLString in
                    self.performSegue(withIdentifier: "toWebView", sender: addressURLString)
                }
                return cell
            }
        case .qr:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "QRDisplayCell",
                                                        for: indexPath) as? QRDisplayCell {
                cell.address = mainViewModel.address
                if let vergeJPY = mainViewModel.vergeJPY {
                    cell.vergeJPY = vergeJPY
                }
                cell.setTextField = { textField in
                    self.targetTextField = textField
                }
                return cell
            }
        case .history:
            if indexPath.row == 0 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionHeaderCell",
                                                            for: indexPath) as? TransactionHeaderCell {
                    cell.blockInfoAddress = mainViewModel.blockInfoAddress
                    return cell
                }
            }
            if let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell",
                                                        for: indexPath) as? TransactionCell {
                if let history = mainViewModel.blockInfoAddress?.history[safe: indexPath.row - 1],
                    let count = mainViewModel.blockInfoAddress?.history.count {
                    cell.history = history
                    cell.tapTX = { txURLString in
                        self.performSegue(withIdentifier: "toWebView", sender: txURLString)
                    }
                     
                    if count == indexPath.row {
                        cell.bottomBlueLine.isHidden = false
                        cell.bottomGrayLine.isHidden = true
                    } else {
                        cell.bottomBlueLine.isHidden = true
                        cell.bottomGrayLine.isHidden = false
                    }
                }
                return cell
            }
        case .footer:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "FooterCell",
                                                        for: indexPath) as? FooterCell {
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func checkTableScroll() {
        let target = IndexPath(row: 0, section: SectionType.qr.hashValue)
        let cellRect = tableView.rectForRow(at: target)
        let cellRectInView = tableView.convert(cellRect, to: self.navigationController?.view)
        print(tableView.scrollIndicatorInsets.top)
        if tableView.frame.minY + tableView.scrollIndicatorInsets.top <= cellRectInView.minY
            && cellRectInView.maxY <= tableView.frame.maxY {
        } else {
            self.tableView.scrollToRow(at: target,
                                       at: .bottom,
                                       animated: true)
        }
    }
}

