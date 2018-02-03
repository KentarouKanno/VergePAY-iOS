//
//  ApplicationAttribute.swift
//  VergePAY iOS
//
//  Created by Kentarou on 2018/02/12.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import Foundation
import UIKit

struct ApplicationAttribute {
    
    static var bundleNameKey = "CFBundleName"
    static var shortVersionKey = "CFBundleShortVersionString"
    static var bundleVersionKey = "CFBundleVersion"
    
    /// CFBundleName
    static let bundleName = Bundle.main.object(forInfoDictionaryKey: ApplicationAttribute.bundleNameKey)
    /// bundleIdentifier
    static let bundleIdentifier = Bundle.main.bundleIdentifier
    /// CFBundleShortVersionString
    static let shortVersion = Bundle.main.object(forInfoDictionaryKey: ApplicationAttribute.shortVersionKey) as? String
    /// CFBundleVersion
    static let bundleVersion = Bundle.main.object(forInfoDictionaryKey: ApplicationAttribute.bundleVersionKey) as? String
    /// iOS Version
    static let iOSVersion = UIDevice.current.systemVersion
    /// screen横サイズ
    static let screenWidth = UIScreen.main.bounds.width
    /// screen縦サイズ
    static let screenHeight = UIScreen.main.bounds.height
    /// iPhone4,iPhone4sの画面高さ
    static let iPhone4DisplayHight: CGFloat = 480
}
