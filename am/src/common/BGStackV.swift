
//
//  ComposeToolBar.swift
//  day-43-microblog
//
//  Created by apple on 15/12/14.
//  Copyright © 2015年 yf. All rights reserved.
//

import UIKit

@available(iOS 9.0, *)
class BGStackV: UIStackView {

    lazy var bg:UIView={
        let v=UIView()
        self.addSubview(v)
        v.translatesAutoresizingMaskIntoConstraints=false
        self.addConstraint(NSLayoutConstraint(item: v, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute:NSLayoutConstraint.Attribute.top , multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: v, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute:NSLayoutConstraint.Attribute.left , multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: v, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute:NSLayoutConstraint.Attribute.width , multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: v, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute:NSLayoutConstraint.Attribute.height , multiplier: 1, constant: 0))
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
