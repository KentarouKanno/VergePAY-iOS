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
        
        let normalAttribute = NSMutableAttributedString(string: normalText)
        normalAttribute.addAttributes([ .foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)],
                                      range: NSRange.allRenge(str: normalText))
        normalAttribute.addAttributes([ .font: UIFont.systemFont(ofSize: 17)],
                                      range: NSRange.allRenge(str: normalText))
        
        let linkAttributed = NSMutableAttributedString(string: linkText)
        switch type {
        case .normal:
            linkAttributed.addAttributes([ .foregroundColor: #colorLiteral(red: 0.2100792089, green: 0.6651423269, blue: 0.8789455387, alpha: 1)],
                                         range: NSRange.allRenge(str: linkText))
        case .selected:
            linkAttributed.addAttributes([ .foregroundColor: #colorLiteral(red: 0.1627971731, green: 0.5154403003, blue: 0.6811233237, alpha: 1)],
                                         range: NSRange.allRenge(str: linkText))
        }
    
        linkAttributed.addAttribute(NSAttributedStringKey.underlineStyle,
                                    value: NSUnderlineStyle.styleSingle.rawValue,
                                    range: NSRange.allRenge(str: linkText))
        linkAttributed.addAttributes([ .font: UIFont.systemFont(ofSize: 17)],
                                     range: NSRange.allRenge(str: linkText))
        
        return [normalAttribute, linkAttributed].joined(separator: "")
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

