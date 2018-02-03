//
//  NavigationTitleView.swift
//  VergePAY iOS
//
//  Created by Kentarou on 2018/02/08.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import UIKit

@IBDesignable class NavigationTitleView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadFromNib()
    }
    
    private func loadFromNib() {
        let v = Bundle(for: type(of: self)).loadNibNamed("NavigationTitleView",
                                                         owner: self, options: nil)?.first as! UIView
        addSubview(v)
        
        // NSLayoutConstraint
        v.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view(==160)]-0-|",
                                                      options: NSLayoutFormatOptions(rawValue: 0),
                                                      metrics: nil,
                                                      views: ["view" : v]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|",
                                                      options: NSLayoutFormatOptions(rawValue: 0),
                                                      metrics: nil,
                                                      views: ["view" : v]))
        
    }
}
