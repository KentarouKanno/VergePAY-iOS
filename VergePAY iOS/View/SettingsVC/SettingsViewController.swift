//
//  SettingsViewController.swift
//  VergePAY iOS
//
//  Created by Kentarou on 2018/02/06.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, PickerCellDelegate {
    
    // datepicker related data
    var pickerIndexPath: IndexPath?
    var pickerVisible: Bool { return pickerIndexPath != nil }
    
    var settingCellItem: SettingCellItem?
    var countryConvertData: CountryConvertData?
    
    enum SectionType: Int, EnumEnumerable {
        case displaySetting
        case appSettings
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(R.nib.displaySwitchCell)
            tableView.register(R.nib.settingHeaderCell)
            tableView.register(R.nib.settingSelectCell)
            tableView.register(R.nib.pickerCell)
            tableView.tableFooterView = UIView()
        }
    }
    
    // MARK: - life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let countryConvertData = countryConvertData {
            settingCellItem = SettingCellItem(currencyData: countryConvertData)
        }
        navigationController?.navigationBar.tintColor = .white
    }
}

extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionType.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = SectionType(rawValue: section) else { return 0 }
        switch sectionType {
        case .displaySetting: return 5
        case .appSettings   : return pickerVisible ? 5 : 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionType = SectionType(rawValue: indexPath.section),
            let settingCellItem = settingCellItem else { return UITableViewCell() }
        
        switch sectionType {
        case .displaySetting:
            if indexPath.row == 0 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.settingHeaderCell,
                                                            for: indexPath) {
                    cell.headerTitle.localizeText = settingCellItem.headerTitleList.first
                    return cell
                }
            }
            if let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.displaySwitchCell,
                                                        for: indexPath) {
                
                cell.cellData = settingCellItem.displaySettingCellList[safe: indexPath.row - 1]
                cell.setBottomLine(isLastCell: settingCellItem.displaySettingCellList.count == indexPath.row)
                return cell
            }
        case .appSettings:
            if indexPath.row == 0 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.settingHeaderCell,
                                                            for: indexPath) {
                    cell.headerTitle.localizeText = settingCellItem.headerTitleList[safe: 1]
                    return cell
                }
            }
            
            if pickerVisible && pickerIndexPath! == indexPath,
                let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.pickerCell,
                                                            for: indexPath) {
                cell.bottomlineReset()
                cell.delegate = self 
                cell.cellData = settingCellItem.appSettingCellList[safe: indexPath.row - 2]
                return cell
                
            }
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.settingSelectCell,
                                                        for: indexPath) {
                if let cellData = calculateFieldForIndexPath(indexPath: indexPath) {
                    cell.cellData = cellData
                    var count = settingCellItem.appSettingCellList.count
                    if let _ = self.pickerIndexPath {
                        count += 1
                    }
                    cell.setBottomLine(isLastCell: count == indexPath.row)
                    return cell
                }
            }
        }
        return UITableViewCell()
    }
    
    func calculateFieldForIndexPath(indexPath: IndexPath) -> SettingCellData? {
        if let settingCellItem = settingCellItem {
            if pickerVisible && pickerIndexPath!.section == indexPath.section {
                if pickerIndexPath!.row == indexPath.row { // we are the date picker. Pick the field below me
                    return settingCellItem.appSettingCellList[safe: indexPath.row - 2]
                } else if pickerIndexPath!.row > indexPath.row { // we are "below" the date picker. Just return the field.
                    return settingCellItem.appSettingCellList[safe: indexPath.row - 1]
                } else { // we are above the datePicker, so we should substract one from the current row index.
                    return settingCellItem.appSettingCellList[safe: indexPath.row - 2]
                }
            } else {
                // The date picker is not showing or not in my section, just return the usual field.
                return settingCellItem.appSettingCellList[indexPath.row - 1]
            }
        }
        return nil
    }
    
    func datePickerIsRightBelowMe(indexPath: IndexPath) -> Bool {
        if pickerVisible && pickerIndexPath!.section == indexPath.section {
            if indexPath.section != pickerIndexPath!.section { return false }
            else { return indexPath.row == pickerIndexPath!.row - 1 }
        } else { return false }
    }
    
    func tableReload() {
        tableView.reloadData()
        setPickerCellBottomLine(isDelay: false)
        setLastCellBottomLine()
    }
}

extension SettingsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 1, indexPath.row != 0  else { return }
        
        
        setPickerCellBottomLine(isReset: true)
        view.layoutIfNeeded()
        
        tableView.beginUpdates()
        if pickerVisible {
            // close datepicker
            tableView.deleteRows(at: [pickerIndexPath!], completion: {
                if let cell = tableView.visibleCells.last as? SettingSelectCell {
                    cell.setBottomLine(isLastCell: true)
                }
            })
            let oldDatePickerIndexPath = pickerIndexPath!
            
            if datePickerIsRightBelowMe(indexPath: indexPath) {
                // just close the datepicker
                self.pickerIndexPath = nil
            } else {
                // open it my new location
                let newRow = oldDatePickerIndexPath.row < indexPath.row ? indexPath.row : indexPath.row + 1
                self.pickerIndexPath = IndexPath(row: newRow, section: indexPath.section)
                if let pickerIndexPath = self.pickerIndexPath {
                    tableView.insertRows(at: [pickerIndexPath]) {
                        self.setPickerCellBottomLine()
                        self.setLastCellBottomLine()
                    }
                }
            }
        } else {
            self.pickerIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            if let pickerIndexPath = self.pickerIndexPath {
                tableView.insertRows(at: [pickerIndexPath]) {
                    self.setPickerCellBottomLine()
                    self.setLastCellBottomLine()
                }
            }
        }
        tableView.endUpdates()
    }
    
    func setPickerCellBottomLine(isDelay: Bool = true, isReset: Bool = false) {
        for cell in tableView.visibleCells {
            if let cell = cell as? PickerCell {
                if isReset {
                    cell.bottomlineReset()
                } else {
                    cell.setBottomLine(isDelay: isDelay)
                }
            }
        }
    }
    
    func setLastCellBottomLine() {
        let index: IndexPath = [1, 4]
        for cell in tableView.visibleCells {
            if let cell = cell as? SettingSelectCell {
                if index == self.pickerIndexPath! {
                    cell.setBottomLine(isLastCell: false)
                }
            }
        }
    }
}
