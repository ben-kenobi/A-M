

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
 let dfTFont=UIFont.systemFont(ofSize: 18)

extension UIButton{

    
    func setTitle(title:String){
        setTitle(title, for: UIControl.State.normal)
    }
    
    @objc func toggleSelected(){
        self.isSelected = !self.isSelected
    }
    convenience init(img:UIImage,selImg:UIImage,title:String) {
        self.init()
        self.setImage(img, for: .normal)
        self.setImage(selImg, for: .selected)
        self.setTitle(title, for: .normal)
        self.addTarget(self, action: #selector(UIButton.toggleSelected), for: .touchUpInside)
          self.setTitleColor(iColor(150, 150, 150), for: .normal)
          self.setTitleColor(iColor(50, 50, 50), for: .selected)
    }
    
    convenience init(frame:CGRect?=nil ,img:UIImage? = nil,hlimg:UIImage? = nil,title:String? = nil,font:UIFont = dfTFont,titleColor:UIColor=dfTColor,titleHlColor:UIColor=dfTHLColor,bgimg:UIImage?=nil,hlbgimg:UIImage?=nil,bgcolor:UIColor?=nil,corner:CGFloat=0,bordercolor:UIColor?=nil,borderW:CGFloat=0, tar:AnyObject? = nil,action:Selector?,tag:Int=0) {
        self.init()
        let b=self
        if let _=img {
            b.setImage(img, for: UIControl.State.normal)
            b.setImage(hlimg, for: UIControl.State.highlighted)
        }
        if let _=title{
            b.setTitle(title, for: UIControl.State.normal)
        }
        
        if let _=bgimg{
            b.setBackgroundImage(bgimg, for: UIControl.State.normal)
            b.setBackgroundImage(hlbgimg, for: UIControl.State.highlighted)
        }
        if let _=bgcolor{
            b.backgroundColor=bgcolor
        }
        if let bordercolor=bordercolor{
            b.layer.borderColor=bordercolor.cgColor
            b.layer.borderWidth=borderW
        }
        
        b.layer.cornerRadius=corner
        b.layer.masksToBounds=corner>0
        b.tag=tag
        
        if let _=tar{
            b.addTarget(tar, action: action!, for: UIControl.Event.touchUpInside)
        }
        b.setTitleColor(titleColor, for: UIControl.State.normal)
        b.setTitleColor(titleHlColor, for: UIControl.State.highlighted)
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
