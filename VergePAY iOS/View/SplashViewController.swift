//
//  SplashViewController.swift
//  QRScan
//
//  Created by Kentarou on 2018/01/30.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    
    private let duration: TimeInterval = 1.0
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var imageBaseView: UIView!

    func delayClose() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
           
            UIView.animate(withDuration: self.duration, animations: {
                
                self.baseView.alpha = 0
                self.imageBaseView.alpha = 0
            }, completion: { finish in
                
                self.dismiss(animated: false, completion: nil)
            })
        }
    }
}
