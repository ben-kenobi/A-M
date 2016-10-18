


//
//  UILabel+Ext.swift
//  day-43-microblog
//
//  Created by apple on 15/12/5.
//  Copyright © 2015年 yf. All rights reserved.
//

import UIKit


extension UILabel{
    convenience init(frame:CGRect?=nil,txt:String="",color:UIColor=dfTColor,font:UIFont?=dfTFont,align:NSTextAlignment=NSTextAlignment.Left,line:Int,bgColor:UIColor=UIColor.clearColor()){
        self.init()
        text=txt
        if let fra = frame{
            self.frame=fra
        }
        textColor=color
        self.font=font
        self.textAlignment=align
        numberOfLines=line
        backgroundColor=bgColor
        
    }
}