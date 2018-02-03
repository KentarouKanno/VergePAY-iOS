//
//  NSAttributedString+.swift
//  
//
//  Created by Kentarou on 2018/02/02.
//

import Foundation
import UIKit

extension NSAttributedString {

    class func linkText(normalText: String = "",
                              linkText: String,
                              type: LinkLabel.SelectedType) -> NSAttributedString {
        
        var defaultColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        switch UserDefaults.standard.themeColor {
        case .light: defaultColor = UIColor.ThemeColor.lightTextColor
        case .dark: defaultColor = UIColor.ThemeColor.darkTextColor
        }
        
        let normalAttribute = NSMutableAttributedString(string: normalText)
        normalAttribute.addAttributes([ .foregroundColor: defaultColor],
                                      range: NSRange.allRenge(str: normalText))
        normalAttribute.addAttributes([ .font: UIFont.avenirNextFont(size: 17)],
                                      range: NSRange.allRenge(str: normalText))
        
        let linkAttributed = NSMutableAttributedString(string: linkText)
        switch type {
        case .normal:
            
            var normalColor: UIColor = #colorLiteral(red: 0.2100792089, green: 0.6651423269, blue: 0.8789455387, alpha: 1)
            if case .dark = UserDefaults.standard.themeColor {
                normalColor = #colorLiteral(red: 0.1785287675, green: 0.5810199219, blue: 0.7727431275, alpha: 1)
            }
            linkAttributed.addAttributes([ .foregroundColor: normalColor],
                                         range: NSRange.allRenge(str: linkText))
        case .selected:
            
            var selectedColor: UIColor = #colorLiteral(red: 0.1627971731, green: 0.5154403003, blue: 0.6811233237, alpha: 1)
            if case .dark = UserDefaults.standard.themeColor {
                selectedColor = #colorLiteral(red: 0.1230448259, green: 0.4004480407, blue: 0.5325866803, alpha: 1)
            }
            linkAttributed.addAttributes([ .foregroundColor: selectedColor],
                                         range: NSRange.allRenge(str: linkText))
        }
    
        linkAttributed.addAttribute(NSAttributedStringKey.underlineStyle,
                                    value: NSUnderlineStyle.styleSingle.rawValue,
                                    range: NSRange.allRenge(str: linkText))
        linkAttributed.addAttributes([ .font: UIFont.avenirNextFont(size: 17)],
                                     range: NSRange.allRenge(str: linkText))
        
        return [normalAttribute, linkAttributed].joined(separator: "")
    }
    
    class func attributedPlaceholder(text: String, isEnable: Bool = true) -> NSAttributedString {
        
        var defaultColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        switch UserDefaults.standard.themeColor {
        case .light: defaultColor = UIColor.ThemeColor.lightPlaceholderColor
        case .dark:
            if isEnable {
                defaultColor = UIColor.ThemeColor.darkPlaceholderColor
            } else {
                defaultColor = UIColor.ThemeColor.darkPlaceholderDisableColor
            }
        }
        
        let normalAttribute = NSMutableAttributedString(string: text)
        normalAttribute.addAttributes([ .foregroundColor: defaultColor],
                                      range: NSRange.allRenge(str: text))
        normalAttribute.addAttributes([ .font: UIFont.avenirNextFont(size: 12)],
                                      range: NSRange.allRenge(str: text))
        return normalAttribute
    }
}

extension Sequence where Iterator.Element == NSAttributedString {
    
    func joined(attributedSeparator: Iterator.Element) -> Iterator.Element {
        let attributedString = self.enumerated()
            .map { (index, element) -> NSAttributedString in
                
                if index == 0 {
                    return element
                }
                // 各要素間にseparatorを挿入
                let mutable = NSMutableAttributedString(attributedString: attributedSeparator)
                mutable.append(element)
                return mutable
            }
            .reduce(NSMutableAttributedString(), { (list, element) -> NSMutableAttributedString in
                // AttributedString配列を一つのAttributedStringに結合
                list.append(element)
                return list
            })
        return Iterator.Element(attributedString: attributedString)
    }
    
    func joined(separator: String) -> Iterator.Element {
        return joined(attributedSeparator: Iterator.Element(string: separator))
    }
}

