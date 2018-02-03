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
    
    enum ConfirmAlertType {
        case camera
        case photo
    }
    
    static func showNOConfirmAlert(vc: UIViewController, type: ConfirmAlertType) {
        var title, message: String
        switch type {
        case .camera:
            title = LocalizedKey.cameraAlertTitle.rawValue.localized
            message = LocalizedKey.cameraAlertMessage.rawValue.localized
        case .photo:
            title = LocalizedKey.photoAlertTitle.rawValue.localized
            message = LocalizedKey.photoAlertMessage.rawValue.localized
        }
        
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: LocalizedKey.cancel.rawValue.localized,
                                                style: .cancel,
                                                handler: nil))
        
        alertController.addAction(UIAlertAction(title: LocalizedKey.toSettings.rawValue.localized,
                                                style: .`default`,
                                                handler: { _ in
                                                    // To iPhone Settings
                                                    UIApplication.shared.open(scheme: UIApplicationOpenSettingsURLString)
        }))
        vc.present(alertController, animated: true, completion: nil)
    }
    
    
    // Show Toast
    static func toast(rootVC: UIViewController? = nil,
                      title: String = "",
                      message: String,
                      duration: TimeInterval = 0.8) {
        
        let alert = UIAlertController(title:title,
                                      message: message,
                                      preferredStyle: .alert)
        
        if let rootVC = rootVC {
            rootVC.present(alert, animated: true, completion: {
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    alert.dismiss(animated: true, completion: nil)
                }
            })
        } else {
            if let rootVC = UIApplication.shared.topViewController {
                rootVC.present(alert, animated: true, completion: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                        alert.dismiss(animated: true, completion: nil)
                    }
                })
            }
        }
    }
    
    static func showQRselectActionSheet(vc: UIViewController,
                                        selectCamera: @escaping (UIAlertAction) -> Void,
                                        selectPhoto: @escaping (UIAlertAction) -> Void) {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: LocalizedKey.camera.rawValue.localized, style: .default) { (action) in
            selectCamera(action)
        }
        let photoAction = UIAlertAction(title: LocalizedKey.photo.rawValue.localized, style: .default) { (action) in
            selectPhoto(action)
        }
        let cancelAction = UIAlertAction(title: LocalizedKey.cancel.rawValue.localized, style: .cancel) { (_) in }
        
        actionSheet.popoverPresentationController?.sourceView = vc.view
        actionSheet.popoverPresentationController?.sourceRect = CGRect(x: vc.view.frame.size.width/2, y: vc.view.frame.size.height, width: 0, height: 0)
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(photoAction)
        actionSheet.addAction(cancelAction)
        vc.present(actionSheet, animated: true, completion: nil)
    }
}
