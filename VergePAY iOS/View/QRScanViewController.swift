//
//  QRScanViewController.swift
//  QRScan
//
//  Created by Kentarou on 2018/01/22.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import UIKit
import AVFoundation

class QRScanViewController: UIViewController {
    
    let vergeAdressByte = 34
    
    // QRコード読み込み完了クロージャー
    var completion: ((String) -> ())?
    
    var isReadQR = false
    var isErrorQR = false 
    
    @IBOutlet weak var qrPlaceholderImageView: UIImageView!
    @IBOutlet weak var flashButton: UIButton!
    
    // セッションのインスタンス生成
    fileprivate let session = AVCaptureSession()
    
    /// カメラ利用の設定ダイアログを表示する
    static func presentCameraUnavailableAlert(fromRoot: UIViewController) {
        UIAlertController.showCameraNOConfirmAlert(vc: fromRoot)
    }
    
    /// カメラへのアクセスが許可されているかどうかを返す
    static var isCameraAllowed: Bool {
        return AVCaptureDevice.authorizationStatus(for: AVMediaType.video) != .denied
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.3679657578, green: 0.7949399352, blue: 0.9167356491, alpha: 1)
        addCameraPreview()
        
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        if !device.hasTorch {
            flashButton.isHidden = true 
        }
    }
    
    /// カメラ画面を追加する
    private func addCameraPreview() {
        
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: device) else { return }
        session.addInput(input)
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.bounds
        view.layer.insertSublayer(previewLayer, at: 0)
        
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: .main)
        session.addOutput(output)
        
        if output.availableMetadataObjectTypes.contains(where: { objectType in
            return objectType == .qr
        }) {
            output.metadataObjectTypes = [.qr]
        } else {
            print("no qr code support")
        }
        
        DispatchQueue(label: "qrscanner").async {
            self.session.startRunning()
        }
    }
    
    @IBAction func tapClose(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func swipeDown(_ sender: UISwipeGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapFlash(_ sender: UIButton) {
        
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                device.torchMode = device.torchMode == .on ? .off : .on
                device.unlockForConfiguration()
                
            } catch let error {
                print("Camera Torch error: \(error)")
            }
        }
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate

extension QRScanViewController : AVCaptureMetadataOutputObjectsDelegate {

    func metadataOutput(_ captureOutput: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let data = metadataObjects as? [AVMetadataMachineReadableCodeObject] {
            if data.count == 0 {
                qrPlaceholderImageView.image = UIImage(named: "QR_Normal")
            } else {
                data.forEach {
                    guard let url = $0.stringValue else { return }
                    
                    let uri = url.replacingOccurrences(of: "verge:", with: "")
                    
                    // Address Validation
                    if uri.count == vergeAdressByte && uri.addressValidation {
                        
                        qrPlaceholderImageView.image = UIImage(named: "QR_Positive")
                        if isReadQR { return }
                        isReadQR = true
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            self.handleURI(uri)
                        }
                    } else {
                        
                        if isErrorQR { return }
                        isErrorQR = true
                        
                        qrPlaceholderImageView.image = UIImage(named: "QR_Negative")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            self.qrPlaceholderImageView.image = UIImage(named: "QR_Normal")
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                self.isErrorQR = false
                            }
                        }
                    }
                }
            }
        }
    }
    
    // スキャンして文字列が読み込まれた時
    func handleURI(_ uri: String) {
        print("\n--- QR Code = 【\(uri)】 ---\n")
        
        completion?(uri)
        dismiss(animated: true, completion: nil)
    }
}

