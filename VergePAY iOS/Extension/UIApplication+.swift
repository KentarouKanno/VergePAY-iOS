//
//  UIApplication+.swift
//  QRScan
//
//  Created by Kentarou on 2018/01/30.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    
    // 現在の最前面のVCを取得する
    var topViewController: UIViewController? {
        guard var topViewController = UIApplication.shared.keyWindow?.rootViewController else { return nil }
        
        while let presentedViewController = topViewController.presentedViewController {
            topViewController = presentedViewController
        }
        
        if let navi = topViewController as? UINavigationController {
            // NavigationControllerの場合は先頭のViewControllerを返す
            return navi.viewControllers.first
        }
        
        if let tab = topViewController as? UITabBarController {
            // TabBarControllerの場合は選択中タブのViewControllerを返す
            
            if let navi = tab.viewControllers![tab.selectedIndex] as? UINavigationController {
                // NavigationControllerの場合は先頭のViewControllerを返す
                return navi.viewControllers.first
            }
            
            return tab.viewControllers![tab.selectedIndex]
        }
        
        return topViewController
    }
    
    
    /// URLをsafariで開く
    ///
    /// - Parameter scheme: URL String
    func open(scheme: String) {
        if let url = URL(string: scheme) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                                            (success) in
                                            print("Open \(scheme): \(success)")
                })
            } else {
                
                let success = UIApplication.shared.openURL(url)
                print("Open \(scheme): \(success)")
            }
        }
    }
    
    var iPhoneXMargin: CGFloat {
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136: print("iPhone 5 or 5S or 5C")
            case 1334: print("iPhone 6/6S/7/8")
            case 2208: print("iPhone 6+/6S+/7+/8+")
            case 2436: return 40 // print("iPhone X")
            default: print("unknown")
            }
        }
        return 0
    }
}
