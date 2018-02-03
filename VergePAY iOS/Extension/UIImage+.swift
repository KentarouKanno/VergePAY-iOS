//
//  UIImage+.swift
//  QRScan
//
//  Created by Kentarou on 2018/01/23.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import UIKit
import CoreGraphics

let π: CGFloat = .pi
private let inputImageKey = "inputImage"

extension UIImage {
    
    static func qrCode(data: Data, color: CIColor) -> UIImage? {
        
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")
        let maskFilter = CIFilter(name: "CIMaskToAlpha")
        let invertFilter = CIFilter(name: "CIColorInvert")
        let colorFilter = CIFilter(name: "CIFalseColor")
        var filter = colorFilter
        
        qrFilter?.setValue(data, forKey: "inputMessage")
        qrFilter?.setValue("L", forKey: "inputCorrectionLevel")
        
        if Double(color.alpha) > .ulpOfOne {
            invertFilter?.setValue(qrFilter?.outputImage, forKey: inputImageKey)
            maskFilter?.setValue(invertFilter?.outputImage, forKey: inputImageKey)
            invertFilter?.setValue(maskFilter?.outputImage, forKey: inputImageKey)
            colorFilter?.setValue(invertFilter?.outputImage, forKey: inputImageKey)
            
            switch UserDefaults.standard.themeColor {
//            case .light: colorFilter?.setValue(color, forKey: "inputColor0")
            case .light: colorFilter?.setValue(CIColor(red: 67.0/255.0, green: 67.0/255.0, blue: 67.0/255.0), forKey: "inputColor0")
            case .dark: colorFilter?.setValue(CIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0), forKey: "inputColor0")
            }
            
        } else {
            maskFilter?.setValue(qrFilter?.outputImage, forKey: inputImageKey)
            filter = maskFilter
        }
        
        // force software rendering for security (GPU rendering causes image artifacts on iOS 7 and is generally crashy)
        let context = CIContext(options: [kCIContextUseSoftwareRenderer: true])
        objc_sync_enter(context)
        defer { objc_sync_exit(context) }
        guard let outputImage = filter?.outputImage else { assert(false, "No qr output image"); return nil }
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { assert(false, "Could not create image."); return nil }
        return UIImage(cgImage: cgImage)
    }
    
    func resize(_ size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { assert(false, "Could not create image context"); return nil }
        guard let cgImage = self.cgImage else { assert(false, "No cgImage property"); return nil }
        
        context.interpolationQuality = .none
        context.rotate(by: π) // flip
        context.scaleBy(x: -1.0, y: 1.0) // mirror
        context.draw(cgImage, in: context.boundingBoxOfClipPath)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    static func imageForColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
    
    // QR UIImage → String
    func performQRCodeDetection() -> (outImage: CIImage?, decode: String) {
        guard let image = CIImage(image: self) else {
            return (nil, "")
        }
        
        var detector: CIDetector?
        var resultImage: CIImage?
        var decode = ""
        
        detector = prepareQRCodeDetector()
        if let detector = detector {
            let features = detector.features(in: image)
            for feature in features as! [CIQRCodeFeature] {
                resultImage = drawHighlightOverlayForPoints(image,
                                                            topLeft: feature.topLeft,
                                                            topRight: feature.topRight,
                                                            bottomLeft: feature.bottomLeft,
                                                            bottomRight: feature.bottomRight)
                decode = feature.messageString!
            }
        }
        return (resultImage, decode)
    }
    
    func prepareQRCodeDetector() -> CIDetector {
        let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        return CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: options)!
    }
    
    func drawHighlightOverlayForPoints(_ image: CIImage, topLeft: CGPoint, topRight: CGPoint,
                                       bottomLeft: CGPoint, bottomRight: CGPoint) -> CIImage {
        var overlay = CIImage(color: CIColor(red: 1.0, green: 0, blue: 0, alpha: 0.5))
        overlay = overlay.cropped(to: image.extent)
        overlay = overlay.applyingFilter("CIPerspectiveTransformWithExtent",
                                         parameters: [
                                            "inputExtent": CIVector(cgRect: image.extent),
                                            "inputTopLeft": CIVector(cgPoint: topLeft),
                                            "inputTopRight": CIVector(cgPoint: topRight),
                                            "inputBottomLeft": CIVector(cgPoint: bottomLeft),
                                            "inputBottomRight": CIVector(cgPoint: bottomRight)
            ])
        return overlay.composited(over: image)
    }
}
