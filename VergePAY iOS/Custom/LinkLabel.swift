//
//  LinkLabel.swift
//  QRScan
//
//  Created by Kentarou on 2018/02/03.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import UIKit


class LinkLabel: UILabel {
    
    var normalText = ""
    var linkText = ""
    
    enum SelectedType {
        case normal
        case selected
    }
    
    var type: SelectedType {
        get { return .normal }
        set(type) {
            switch type {
            case .normal: setNormal()
            case .selected: setSelected()
            }
        }
    }
    
    func setNormal() {
        self.attributedText = NSAttributedString.linkText(normalText: normalText,
                                                          linkText: linkText,
                                                          type: .normal)
    }
    
    func setSelected() {
        self.attributedText = NSAttributedString.linkText(normalText: normalText,
                                                          linkText: linkText,
                                                          type: .selected)
    }
}
