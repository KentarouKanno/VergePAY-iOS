 //
//  AppDelegate.swift
//  QRScan
//
//  Created by Kentarou on 2018/01/22.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import UIKit
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UIBarButtonItem.appearance().setTitleTextAttributes([.font: UIFont.avenirNextFont(size: 18)], for: .normal)
        progressSetting()
        UserDefaults.standard.defaultSetting()
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.progressSetting),
                                               name: .uiUpdateNotification,
                                               object: nil)
        return true
    }
    
    @objc func progressSetting() {
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.resetOffsetFromCenter()
        
        var foregroundColor = UIColor.ThemeColor.progressLightForeColor
        var backgroundColor = UIColor.ThemeColor.progressLightBackColor
        switch UserDefaults.standard.themeColor {
        case .light: break
        case .dark:
            foregroundColor = UIColor.ThemeColor.progressDarkForeColor
            backgroundColor = UIColor.ThemeColor.progressDarkBackColor
        }
        SVProgressHUD.setForegroundColor(foregroundColor)
        SVProgressHUD.setBackgroundColor(backgroundColor)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        if let topVC = UIApplication.shared.topViewController,
            let splashVC = topVC as? SplashViewController {
            splashVC.delayClose()
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        showSplash()
    }
    
    func showSplash() {
        if let topVC = UIApplication.shared.topViewController,
            let splashVC = R.storyboard.splash().instantiateInitialViewController() {
            
            if topVC is UIAlertController { return }
            topVC.view.endEditing(true)
            splashVC.modalPresentationStyle = .overCurrentContext
            topVC.present(splashVC, animated: false, completion: nil)
        }
    }
}


