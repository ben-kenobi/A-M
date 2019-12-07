//
//  CopyBtn.swift
//  am
//
//  Created by apple on 16/11/3.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class CBBtn: UIButton {
    var cb:((_ sender:UIButton)->())?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(self.onClick(_:)), for: UIControl.Event.touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onClick(_ sender:UIButton){
        cb?(sender)
    }

}
