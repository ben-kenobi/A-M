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
            return UIColor(CGColor: c)
        }
        set{
            layer.borderColor=newValue?.CGColor
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
            layer.borderWidth=borderW
            layer.borderColor=borderColor.CGColor

        }
        
    }
    
    func addCurve(tl:(Bool,CGFloat),tr:(Bool,CGFloat),br:(Bool,CGFloat),bl:(Bool,CGFloat),bounds:CGRect){
        let w=bounds.width
        let h=bounds.height
        let path:CGMutablePath=CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 0, 1)
        if tl.0{
            CGPathAddArcToPoint(path, nil, 0, 0, 1, 0, tl.1)
        }else{
            CGPathAddLineToPoint(path, nil, 0, 0)
        }
        if tr.0{
            CGPathAddArcToPoint(path, nil, w, 0, w, 1, tr.1)
        }else{
            CGPathAddLineToPoint(path, nil, w, 0)

        }
        if br.0{
           CGPathAddArcToPoint(path, nil, w, h, w-1, h, br.1)
        }else{
            CGPathAddLineToPoint(path, nil, w, h)
        }
        if bl.0{
            CGPathAddArcToPoint(path, nil, 0, h,0, h-1, br.1)
        }else{
            CGPathAddLineToPoint(path, nil, 0, h)
        }
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = path
        self.layer.mask = maskLayer
        
        
    }
    
}

