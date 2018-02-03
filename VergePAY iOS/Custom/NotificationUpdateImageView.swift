//
//  NotificationUpdateImage.swift
//  VergePAY iOS
//
//  Created by Kentarou on 2018/02/14.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import Foundation
import UIKit

enum ImageViewType {
    case none
    case qrNoneImage
}

class NotificationUpdateImageView: UIImageView, NotificationUpdateProtocol {
    
    var imageViewType: ImageViewType = .none
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
        
        if case .qrNoneImage = self.imageViewType {
            switch UserDefaults.standard.themeColor {
            case .light: self.image = R.image.qrPlaceholderLight()
            case .dark: self.image = R.image.qrPlaceholderDark()
            }
            return
        }
        
        switch UserDefaults.standard.themeColor {
        case .light: self.image = lightImage
        case .dark: self.image = darkImage
        }
    }
}
