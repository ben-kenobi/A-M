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
            layer.borderWidth=borderW
            layer.borderColor=borderColor.cgColor

        }
        
    }
    
    func addCurve(tl:(Bool,CGFloat),tr:(Bool,CGFloat),br:(Bool,CGFloat),bl:(Bool,CGFloat),bounds:CGRect){
        let w=bounds.width
        let h=bounds.height
        let path:CGMutablePath=CGMutablePath()
        path.move(to: CGPoint(x:0,y:1))
        
        if tl.0{
            path.addArc(tangent1End: CGPoint(x:0,y:0), tangent2End: CGPoint(x:1,y:0), radius: tl.1)
        }else{
            path.addLine(to: CGPoint(x:0,y:0))
        }
        if tr.0{
            path.addArc(tangent1End: CGPoint(x:w,y:0), tangent2End: CGPoint(x:w,y:1), radius: tr.1)
        }else{
            path.addLine(to: CGPoint(x:w,y:0))
        }
        if br.0{
            path.addArc(tangent1End: CGPoint(x:w,y:h), tangent2End: CGPoint(x:w-1,y:h), radius: br.1)
        }else{
            path.addLine(to: CGPoint(x:w,y:h))
        }
        if bl.0{
              path.addArc(tangent1End: CGPoint(x:0,y:h), tangent2End: CGPoint(x:0,y:h-1), radius: bl.1)
        }else{
            path.addLine(to: CGPoint(x:0,y:h))
        }
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = path
        self.layer.mask = maskLayer
        
        
    }
    
}

