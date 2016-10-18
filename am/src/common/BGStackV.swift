
//
//  ComposeToolBar.swift
//  day-43-microblog
//
//  Created by apple on 15/12/14.
//  Copyright © 2015年 yf. All rights reserved.
//

import UIKit

class BGStackV: UIStackView {

    lazy var bg:UIView={
        let v=UIView()
        self.addSubview(v)
        v.translatesAutoresizingMaskIntoConstraints=false
        self.addConstraint(NSLayoutConstraint(item: v, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute:NSLayoutAttribute.Top , multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: v, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute:NSLayoutAttribute.Left , multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: v, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute:NSLayoutAttribute.Width , multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: v, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute:NSLayoutAttribute.Height , multiplier: 1, constant: 0))
        return v
    }()
    
    override var backgroundColor:UIColor?{
        set{
         self.bg.backgroundColor=newValue
        }
        get{
            return self.bg.backgroundColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .Horizontal
        distribution = .FillEqually
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
