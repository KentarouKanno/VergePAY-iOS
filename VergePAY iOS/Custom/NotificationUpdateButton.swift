//
//  NotificationUpdateButton.swift
//  VergePAY iOS
//
//  Created by Kentarou on 2018/02/14.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import Foundation
import UIKit


class NotificationUpdateButton: UIButton, NotificationUpdateProtocol {
    
    var lightImage: UIImage?
    var darkImage: UIImage?
    
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
        
        switch UserDefaults.standard.themeColor {
        case .light: self.setImage(lightImage, for: .normal)
        case .dark: self.setImage(darkImage, for: .normal)
        }
    }
}
