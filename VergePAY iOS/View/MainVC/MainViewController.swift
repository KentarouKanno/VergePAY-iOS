//
//  ViewController.swift
//  QRScan
//
//  Created by Kentarou on 2018/01/22.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import UIKit
import Photos
import SVProgressHUD

class MainViewController: UIViewController {
    
    var action: [(() -> Void)] = []
    
    enum SectionType: Int, EnumEnumerable {
        case market
        case calculate
        case address
        case account
        case qr
        case history
        case footer
    }
    
    var mainViewModel = MainViewModel()
    private var isAccountCellOpen = false
    private var isShowKeyboard  = false
    private var imagePickerController = UIImagePickerController()
    
    @IBOutlet weak var tableBottomConstraints: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(R.nib.marketCell)
            tableView.register(R.nib.calculateCell)
            tableView.register(R.nib.qrScanCell)
            tableView.register(R.nib.qrScanCell)
            tableView.register(R.nib.acountCell)
            tableView.register(R.nib.qrDisplayCell)
            tableView.register(R.nib.transactionHeaderCell)
            tableView.register(R.nib.transactionCell)
            tableView.register(R.nib.footerCell)
            tableView.tableFooterView = UIView()
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.368627451, green: 0.7960784314, blue: 0.9176470588, alpha: 1)
        addKeyboardNotification()
        
        mainViewModel.marketPriceUpdate = { marketPrice in
            if self.isShowKeyboard { return }
            DispatchQueue.mainSyncSafe {
                self.tableView.visibleCells.forEach({ cell in
                    if let cell = cell as? MarketCell {
                        cell.updateMarketPrice(marketPrice: marketPrice)
                    }
                    
                    if let cell = cell as? AcountCell {
                        cell.updateAmount(accountAmount: self.mainViewModel.accountAmount)
                    }
                    
                    if let cell = cell as? CalculateCell {
                        if let vergeRate = self.mainViewModel.vergeRate {
                            cell.vergeRate = vergeRate
                        }
                    }
                    
                    if let cell = cell as? QRDisplayCell {
                        if let vergeRate = self.mainViewModel.vergeRate {
                            cell.vergeRate = vergeRate
                        }
                    }
                })
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let address = UserDefaults.standard.address, mainViewModel.address == nil {
            mainViewModel.address = address
            DispatchQueue.asyncAfter(delayTime: 0.5, work: {
                self.searchAddress()
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserDefaults.standard.showHistory, let _ = mainViewModel.blockInfoAddress {
            isAccountCellOpen = true
        }
        tableView.reloadData()
    }
    
    // Set Notification
    func addKeyboardNotification() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(willShowKeyboard(notification:)), name: .UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(didShowKeyboard(notification:)), name: .UIKeyboardDidShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(willHideKeyboard(notification:)), name: .UIKeyboardWillHide, object: nil)
        notificationCenter.addObserver(self, selector: #selector(didHideKeyboard(notification:)), name: .UIKeyboardDidHide, object: nil)
        notificationCenter.addObserver(self, selector: #selector(willChangeKeyboard(notification:)), name: .UIKeyboardWillChangeFrame, object: nil)
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
                })
            }
        }
    }
    
    // DidShow Keyboad
    @objc func didShowKeyboard(notification: Notification) {
        
        if let userInfo = (notification as NSNotification).userInfo {
            if let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval {
                
                UIView.animate(withDuration: duration, animations: {
                    
                }, completion: { _ in
                    
                    self.action.forEach { $0() }
                    self.action.removeAll()
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
                UIView.animate(withDuration: duration, animations: {
                    self.view.layoutIfNeeded()
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
                    // キーボードを下げた後に実行する
                    self.action.forEach { $0() }
                    self.action.removeAll()
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
                self.searchAddress()
            }
        }
        
        if let settingVC = R.segue.mainViewController.toSettings(segue: segue)?.destination {
            if let currencyData = mainViewModel.countryConvertData {
                settingVC.countryConvertData = currencyData
            } else {
                settingVC.countryConvertData = CountryConvertData()
            }
        }
        
        if let webView = R.segue.mainViewController.toWebView(segue: segue)?.destination,
            let urlString = sender as? String {
            webView.urlString = urlString
        }
    }
    
    func searchAddress() {
        let uri = mainViewModel.address ?? ""
        
        SVProgressHUD.show()
        
        BlockInfoAPIModel.getAdressInfo(address: uri) { result in
            
            SVProgressHUD.dismiss()
            
            if let result = result {
                
                self.mainViewModel.blockInfoAddress = result
                UserDefaults.standard.address = uri
                
                if UserDefaults.standard.showAccount {
                    
                    if self.tableView.numberOfRows(inSection: SectionType.account.hashValue) == 0 {
                        
                        self.tableView.insertRows(at: [IndexPath(row: 0,
                                                                 section: SectionType.account.hashValue)], animation: .automatic) {
                                                                    
                                                                    self.isAccountCellOpen = true
                                                                    
                                                                    if UserDefaults.standard.showHistory {
                                                                        
                                                                        var indexArray: [IndexPath] = []
                                                                        
                                                                        if let count = self.mainViewModel.blockInfoAddress?.history.count {
                                                                            
                                                                            for num in 0...count {
                                                                                let index = IndexPath(row: num,
                                                                                                      section: SectionType.history.hashValue)
                                                                                indexArray.append(index)
                                                                            }
                                                                            
                                                                            self.tableView.insertRows(at: indexArray, animation: .automatic) {
                                                                                self.tableView.reloadData()
                                                                            }
                                                                        }
                                                                    }
                                                                    
                                                                    
                        }
                    } else {
                        
                        self.isAccountCellOpen = true
                        self.tableView.reloadData()
                    }
                } else {
                    
                    if self.tableView.numberOfRows(inSection: SectionType.history.hashValue) == 0 {
                        if UserDefaults.standard.showHistory {
                            
                            self.isAccountCellOpen = true
                            var indexArray: [IndexPath] = []
                            
                            if let count = self.mainViewModel.blockInfoAddress?.history.count {
                                
                                for num in 0...count {
                                    let index = IndexPath(row: num,
                                                          section: SectionType.history.hashValue)
                                    indexArray.append(index)
                                }
                                
                                self.tableView.insertRows(at: indexArray, animation: .automatic) {
                                    self.tableView.reloadData()
                                }
                            }
                        }
                    } else {
                        
                        self.isAccountCellOpen = true
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    @IBAction func toSetting(_ sender: UIButton) {
        view.endEditing(true)
        performSegue(withIdentifier: R.segue.mainViewController.toSettings, sender: nil)
    }
    
    func showQRselectActionSheet() {
        
        UIAlertController.showQRselectActionSheet(vc: self, selectCamera: { (cameraAction) in
            
            if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
                self.performSegue(withIdentifier: R.segue.mainViewController.toQRScan, sender: nil)
            } else {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                    if granted {
                       self.performSegue(withIdentifier: R.segue.mainViewController.toQRScan, sender: nil)
                    } else {
                        QRScanViewController.presentCameraUnavailableAlert(fromRoot: self)
                    }
                })
            }
        }) { (photoAction) in
            
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized:
                    
                    self.imagePickerController.delegate = self
                    self.present(self.imagePickerController, animated: true)
                default:
                    QRScanViewController.presentPhotoUnavailableAlert(fromRoot: self)
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
        case .market: return UserDefaults.standard.showMarket ? 1 : 0
        case .calculate: return UserDefaults.standard.showCalculate ? 1 : 0
        case .address: return 1
        case .account:
            guard UserDefaults.standard.showAccount else  { return 0 }
            return mainViewModel.blockInfoAddress == nil ? 0 : 1
        case .qr: return 1
        case .history:
            guard UserDefaults.standard.showHistory else { return 0 }
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
            if let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.marketCell,
                                                        for: indexPath) {
                
                cell.updateMarketPrice(marketPrice: mainViewModel.marketPrice,
                                       isAnimation: false)
                return cell
            }
        case .calculate:
            if let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.calculateCell,
                                                        for: indexPath) {

                cell.vergeRate = mainViewModel.vergeRate
                return cell
            }
        case .address:
            if let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.qrScanCell,
                                                        for: indexPath) {
                cell.toScanVC  = {
                    self.showQRselectActionSheet()
                }
                cell.toAddressSearch = { uri in
                    
                    self.mainViewModel.address = uri
                    
                    if self.isShowKeyboard {
                        self.action = []
                        self.action.append(self.searchAddress)
                        self.view.endEditing(true)
                    } else {
                        self.searchAddress()
                    }
                }
                
                cell.rootViewController = self
                cell.setTargetTextField = {
                    self.action.removeAll()
                }
                return cell
            }
        case .account:
            if let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.acountCell,
                                                        for: indexPath) {
                
                cell.blockInfoAddress = mainViewModel.blockInfoAddress
                cell.updateAmount(accountAmount: mainViewModel.accountAmount)
                
                cell.tapAddress = { addressURLString in
                    self.performSegue(withIdentifier: R.segue.mainViewController.toWebView,
                                      sender: addressURLString)
                }
                return cell
            }
        case .qr:
            if let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.qrDisplayCell,
                                                        for: indexPath) {
                cell.address = mainViewModel.address
                if let vergeRate = mainViewModel.vergeRate {
                    cell.vergeRate = vergeRate
                }
                cell.setTargetTextField = {
                    self.action.append(self.checkTableScroll)
                }
                return cell
            }
        case .history:
            if indexPath.row == 0 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.transactionHeaderCell,
                                                            for: indexPath) {
                    cell.blockInfoAddress = mainViewModel.blockInfoAddress
                    return cell
                }
            }
            if let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.transactionCell,
                                                        for: indexPath) {
                if let history = mainViewModel.blockInfoAddress?.history[safe: indexPath.row - 1],
                    let count = mainViewModel.blockInfoAddress?.history.count {
                    cell.history = history
                    cell.tapTX = { txURLString in
                        self.performSegue(withIdentifier: R.segue.mainViewController.toWebView,
                                          sender: txURLString)
                    }
                    cell.setBottomLine(isLastCell: count == indexPath.row)
                }
                return cell
            }
        case .footer:
            if let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.footerCell,
                                                        for: indexPath) {
                return cell
            }
        }
        return UITableViewCell()
    }
    
    private func checkTableScroll() {
        let target = IndexPath(row: 0, section: SectionType.qr.hashValue)
        let cellRect = tableView.rectForRow(at: target)
        let cellRectInView = tableView.convert(cellRect, to: self.navigationController?.view)
        if tableView.frame.minY + tableView.scrollIndicatorInsets.top <= cellRectInView.minY
            && cellRectInView.maxY <= tableView.frame.maxY {
        } else {
            self.tableView.scrollToRow(at: target, at: .bottom, animated: true)
        }
    }
}

// MARK: - UIImagePickerControllerDelegate

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Call Selected Photo
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let result = image.performQRCodeDetection()
            let address = result.decode.removeVergeString
            
            // Address Validation
            if address.addressLengthValidation && address.addressFormatValidation {
                mainViewModel.address = address
                searchAddress()
                imagePickerController.dismiss(animated: true, completion: nil)
            } else {
                
                // QR Read Error 
                imagePickerController.dismiss(animated: true, completion: {
                    let alert = UIAlertController(title: nil, message: LocalizedKey.qrReadFailed.rawValue.localized, preferredStyle: .alert)
                    alert.addAction( UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                })
            }
        }
    }
}

