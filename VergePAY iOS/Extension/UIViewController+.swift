//
//  UIViewController.swift
//  QRScan
//
//  Created by Kentarou on 2018/02/02.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    
    static func showCameraNOConfirmAlert(vc: UIViewController) {
        // カメラへのアクセスが許可されていません
        let alertController = UIAlertController(title: "カメラへのアクセスが許可されていません",
                                                message: "設定画面へ移動し、カメラへのアクセス許可をしてください。",
                                                preferredStyle: .alert)
        // 『キャンセルボタン』
        alertController.addAction(UIAlertAction(title: "Cancel",
                                                style: .cancel,
                                                handler: nil))
        // 『設定ボタン』
        alertController.addAction(UIAlertAction(title: "Setting",
                                                style: .`default`,
                                                handler: { _ in
                                                    // 設定画面へ遷移する
                                                    UIApplication.shared.open(scheme: UIApplicationOpenSettingsURLString)
        }))
        // アラートを表示
        vc.present(alertController, animated: true, completion: nil)
    }
}
