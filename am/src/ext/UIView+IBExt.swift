//
//  UIView+IBExt.swift
//  day-43-microblog
//
//  Created by apple on 15/12/5.
//  Copyright © 2015年 yf. All rights reserved.
//

import UIKit

@IBDesignable
extension UIView{
    
    @IBInspectable var cornerRadius:CGFloat{
        get{
            return layer.cornerRadius
        }
        set{
            layer.cornerRadius=newValue
            layer.masksToBounds=cornerRadius>0
        }
    }
    
    
    @IBInspectable var borderColor:UIColor?{
        get{
            guard let c=layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: c)
        }
        set{
            layer.borderColor=newValue?.cgColor
        }
    }
    
    @IBInspectable var borderWidth:CGFloat{
        get{
            return layer.borderWidth
        }
        set{
            layer.borderWidth=newValue
        }
    }
    
    
    convenience init(frame:CGRect?=nil,bg:UIColor,corner:CGFloat=0,bordercolor:UIColor?=nil,borderW:CGFloat=0){
        self.init()

        if let fra = frame{
            self.frame=fra
        }
        backgroundColor=bg
        layer.cornerRadius=corner
        layer.masksToBounds=corner>0
        if let borderColor=bordercolor {
            layer.borderColor=borderColor.cgColor
            layer.borderWidth=borderW
        }
        
    }
}

