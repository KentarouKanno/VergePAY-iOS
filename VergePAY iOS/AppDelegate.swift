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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        progressSetting()
        return true
    }
    
    func progressSetting() {
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.resetOffsetFromCenter()
        SVProgressHUD.setBackgroundColor(#colorLiteral(red: 0.9456446767, green: 0.9402881265, blue: 0.9497665763, alpha: 1))
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        if let topVC = UIApplication.shared.topViewController,
            let splashVC = topVC as? SplashViewController {
            splashVC.delayClose()
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        if let topVC = UIApplication.shared.topViewController,
            let splashVC = UIStoryboard(name: "Splash", bundle: nil).instantiateInitialViewController() {
            topVC.view.endEditing(true)
            splashVC.modalPresentationStyle = .overCurrentContext
            topVC.present(splashVC, animated: false, completion: nil)
        }
    }
}


// TODO: -

// バックグラウンドでタイマーを止める
// フォアグラウンド時に何か乗っている？
// フォアグラウンド遷移時にBTC価格を取得し直す
// カンマ区切り 桁数あふれ対応
// 履歴機能
// 言語切替
// 法定通貨切り替え
// カラーテーマ
// インジケーターアニメーション
// WebView Toolbar

// 済






