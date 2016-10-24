
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
        self.addConstraint(NSLayoutConstraint(item: v, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute:NSLayoutAttribute.top , multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: v, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute:NSLayoutAttribute.left , multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: v, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self, attribute:NSLayoutAttribute.width , multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: v, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self, attribute:NSLayoutAttribute.height , multiplier: 1, constant: 0))
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
        axis = .horizontal
        distribution = .fillEqually
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
