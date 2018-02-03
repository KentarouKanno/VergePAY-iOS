//
//  PickerCell.swift
//  VergePAY iOS
//
//  Created by Kentarou on 2018/02/06.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import UIKit

protocol PickerCellDelegate {
    func tableReload()
}

class PickerCell: UITableViewCell,
                  UIPickerViewDataSource,
                  UIPickerViewDelegate {
    
    var delegate: PickerCellDelegate?
    
    @IBOutlet weak var bottomGrayLine: UIView!
    @IBOutlet weak var bottomBlueLine: UIView!
    
    var list:[String] = []
    var key: UserDefaults.key?

    @IBOutlet weak var picker: UIPickerView! 
    
    var cellData: SettingCellData? {
        didSet {
            if let cellData = cellData {
                
                picker.delegate = self
                picker.dataSource = self
                
                key = cellData.userDefaultKey
                list = cellData.list
                
                if let index = list.index(of: cellData.value) {
                    picker.selectRow(index, inComponent: 0, animated: false)
                    picker.reloadAllComponents()
                }
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return list[safe: row]?.localized
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = NotificationUpdateLabel(frame: CGRect(x: 0,
                                                          y: 0,
                                                          width: ApplicationAttribute.screenWidth,
                                                          height: 40))
        label.localizeText = list[safe: row]
        label.font = .avenirNextFont(size: 20)
        label.textAlignment = .center
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let key = key, let value = list[safe: row] {
            cellData?.value = value
            UserDefaults.standard.setValue(key: key, value: value)
            
            if let cellData = cellData,
                let pickerType = cellData.pickerType {
                switch pickerType {
                case .language:
                    let localized = row == 0 ? UserDefaults.UDLocalizedKey.english : UserDefaults.UDLocalizedKey.japanease
                    UserDefaults.standard.setlocalized(key:  localized)
                case .currency: 
                    if let currency = list[safe: row] {
                        NotificationCenter.default.post(name: .rateChangeNotification, object: nil)
                        UserDefaults.standard.setValue(key: UserDefaults.key.currency, value: currency)
                    }
                case .colorTheme:
                    UserDefaults.standard.themeColor = row == 0 ? .light : .dark
                }
            }
            
            NotificationCenter.default.post(name: .uiUpdateNotification, object: nil)
            delegate?.tableReload()
        }
    }
    
    func bottomlineReset() {
        bottomGrayLine.isHidden = true
        bottomBlueLine.isHidden = true
    }
    
    func setBottomLine(isDelay: Bool = true) {
        
        var isLastCell = false
        if let cellData = self.cellData,
            let pickerType = cellData.pickerType,
            case .colorTheme = pickerType {
            isLastCell = true
        }
        
        let delay = isDelay ? 0.2 : 0.0
        DispatchQueue.asyncAfter(delayTime: delay) {
            self.bottomGrayLine.isHidden = isLastCell ? true : false
            self.bottomBlueLine.isHidden = isLastCell ? false : true
        }
    }
}
