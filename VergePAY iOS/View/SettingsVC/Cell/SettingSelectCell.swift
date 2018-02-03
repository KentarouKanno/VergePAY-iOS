//
//  LanguageSelectCell.swift
//  VergePAY iOS
//
//  Created by Kentarou on 2018/02/06.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import UIKit

protocol SettingSelectCellDelegate {
    func tapCell(index: IndexPath)
}

class SettingSelectCell: UITableViewCell {
    
    var isLastCell = false
    
    @IBOutlet weak var settingTitle: NotificationUpdateLabel!
    @IBOutlet weak var valueLabel: NotificationUpdateLabel!
    
    @IBOutlet weak var bottomGrayLine: UIView!
    @IBOutlet weak var bottomBlueLine: UIView!
    
    var key: UserDefaults.key?
    
    var cellData: SettingCellData? {
        didSet {
            if let cellData = cellData {
                
                let key = cellData.userDefaultKey
                self.key = key
                valueLabel.localizeText = cellData.value
                settingTitle.localizeText = cellData.title
            }
        }
    }
    
    func setBottomLine(isLastCell: Bool) {
        self.isLastCell = isLastCell
        bottomGrayLine.isHidden = isLastCell ? true : false
        bottomBlueLine.isHidden = isLastCell ? false : true
    }
}
