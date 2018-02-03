//
//  NotificationUpdateView.swift
//  VergePAY iOS
//
//  Created by Kentarou on 2018/02/09.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import UIKit

enum NotificationViewType {
    case none
    case footerView
}

class NotificationUpdateView: UIView, NotificationUpdateProtocol {
    
    var notificationViewType: NotificationViewType = .none
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialize()
    }
    
    func initialize() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.update),
                                               name: .uiUpdateNotification,
                                               object: nil)
        
        update()
    }
    
    @objc func update() {
        
        if case .footerView = self.notificationViewType {
            switch UserDefaults.standard.themeColor {
            case .light: self.backgroundColor = UIColor.ThemeColor.lightGrayBackColor
            case .dark: self.backgroundColor = UIColor.ThemeColor.darkGrayBackColor
            }
            return
        }
        
        switch UserDefaults.standard.themeColor {
        case .light: self.backgroundColor = UIColor.ThemeColor.lightBackColor
        case .dark: self.backgroundColor = UIColor.ThemeColor.darkBackColor
        }
    }
}
