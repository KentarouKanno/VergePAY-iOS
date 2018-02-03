//
//  DisplaySwitchCell.swift
//  VergePAY iOS
//
//  Created by Kentarou on 2018/02/08.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import UIKit

class DisplaySwitchCell: UITableViewCell {

    @IBOutlet weak var titleLabel: NotificationUpdateLabel!
    @IBOutlet weak var settingSwitch: UISwitch!
    
    @IBOutlet weak var bottomGrayLine: UIView!
    @IBOutlet weak var bottomBlueLine: UIView!
    var key: UserDefaults.key?
    
    var cellData: SettingCellData? {
        didSet {
            if let cellData = cellData {
                
                let key = cellData.userDefaultKey
                self.key = key
                settingSwitch.isOn = UserDefaults.standard.getValue(key: key)
                titleLabel.localizeText = cellData.title
            }
        }
    }
    
    @IBAction func valueChanged(_ sender: UISwitch) {
        if let key = key {
            UserDefaults.standard.setValue(key: key, value: sender.isOn)
        }
    }
    
    func setBottomLine(isLastCell: Bool) {
        bottomGrayLine.isHidden = isLastCell ? true : false
        bottomBlueLine.isHidden = isLastCell ? false : true
    }
}
