

//
//  UIBarButton+Ext.swift
//  day-43-microblog
//
//  Created by apple on 15/12/5.
//  Copyright © 2015年 yf. All rights reserved.
//

import UIKit
 let dfTColor=UIColor(white: 80.0/255.0, alpha: 1)
 let dfTHLColor=UIColor(white: 180.0/255.0, alpha: 1)
 let dfTFont=UIFont.systemFontOfSize(18)

extension UIButton{

    
    func setTitle(title:String){
        setTitle(title, forState: UIControlState.Normal)
    }
    
    func toggleSelected(){
        self.selected = !self.selected
    }
    convenience init(img:UIImage,selImg:UIImage,title:String) {
        self.init()
        self.setImage(img, forState: .Normal)
        self.setImage(selImg, forState: .Selected)
        self.setTitle(title, forState: .Normal)
        self.addTarget(self, action: #selector(UIButton.toggleSelected), forControlEvents: .TouchUpInside)
          self.setTitleColor(iColor(150, 150, 150), forState: .Normal)
          self.setTitleColor(iColor(50, 50, 50), forState: .Selected)
    }
    
    convenience init(frame:CGRect?=nil ,img:UIImage? = nil,hlimg:UIImage? = nil,title:String? = nil,font:UIFont = dfTFont,titleColor:UIColor=dfTColor,titleHlColor:UIColor=dfTHLColor,bgimg:UIImage?=nil,hlbgimg:UIImage?=nil,bgcolor:UIColor?=nil,corner:CGFloat=0,bordercolor:UIColor?=nil,borderW:CGFloat=0, tar:AnyObject? = nil,action:Selector,tag:Int=0) {
        self.init()
        let b=self
        if let _=img {
            b.setImage(img, forState: UIControlState.Normal)
            b.setImage(hlimg, forState: UIControlState.Highlighted)
        }
        if let _=title{
            b.setTitle(title, forState: UIControlState.Normal)
        }
        
        if let _=bgimg{
            b.setBackgroundImage(bgimg, forState: UIControlState.Normal)
            b.setBackgroundImage(hlbgimg, forState: UIControlState.Highlighted)
        }
        if let _=bgcolor{
            b.backgroundColor=bgcolor
        }
        if let bordercolor=bordercolor{
            b.layer.borderColor=bordercolor.CGColor
            b.layer.borderWidth=borderW
        }
        
        b.layer.cornerRadius=corner
        b.layer.masksToBounds=corner>0
        b.tag=tag
        
        if let _=tar{
            b.addTarget(tar, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        }
        b.setTitleColor(titleColor, forState: UIControlState.Normal)
        b.setTitleColor(titleHlColor, forState: UIControlState.Highlighted)
        b.titleLabel?.font=font
        
        if let iframe=frame{
            b.frame=iframe
        }else{
            b.sizeToFit()
        }
       
    }
}




extension UIBarButtonItem{
    
    
    convenience init(frame:CGRect?=nil ,img:UIImage? = nil,hlimg:UIImage? = nil,title:String? = nil,font:UIFont = dfTFont,titleColor:UIColor=dfTColor,titleHlColor:UIColor=dfTHLColor, tar:AnyObject? = nil,action:Selector) {
        self.init()
        let btn = UIButton(frame: frame, img: img, hlimg: hlimg, title: title, font: font, titleColor: titleColor, titleHlColor: titleHlColor, tar: tar, action: action)
        customView=btn
  
    }
}