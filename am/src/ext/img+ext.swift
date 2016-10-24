

//
//  img+ext.swift
//  day-43-microblog
//
//  Created by apple on 15/12/5.
//  Copyright © 2015年 yf. All rights reserved.
//

import UIKit
import AVFoundation



extension UIImage{
    
    
    var h:CGFloat{
        return size.height
    }
    var w:CGFloat{
        return size.width
    }
    
    func stretch()->UIImage{
        let v=size.height*0.5,
        h=size.width*0.5
        return  resizableImage(withCapInsets: UIEdgeInsets(top: v, left: h, bottom: v, right: h), resizingMode: UIImageResizingMode.stretch)
    }
    
    func roundImg(_ w:CGFloat=0,boderColor:UIColor?=nil,borderW:CGFloat=0)->UIImage{
        let w2=(h>self.w ? self.w : h)
        let r = w == 0 ? w2 : w
        let scale = r/w2
        let rad=r*0.5+borderW
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width:rad*2, height:rad*2), false, 0)
        let con:CGContext=UIGraphicsGetCurrentContext()!
        if borderW>0{
            con.addArc(center: CGPoint(x:rad,y:rad), radius: rad, startAngle: 0, endAngle:CGFloat(2 * M_PI), clockwise: false)
            
            boderColor?.setFill()
            con.drawPath(using: CGPathDrawingMode.fill)
        }
        con.addArc(center: CGPoint(x:rad,y:rad), radius: rad*0.5, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: false)
        con.clip()
        
        draw(in:CGRect(x:r-scale*self.w+borderW, y: r-scale*self.h+borderW, width: scale*self.w, height: scale*h))
        
        let img=UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
        
    }
    
    func scale2w(_ pixel:CGFloat)->UIImage{
        let size = CGSize(width:pixel, height:pixel/w*h)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        draw(in:CGRect(x:0,y: 0, width:size.width, height:size.height))
        let img=UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    
    class func launchImg()->UIImage?{
        let dict=iBundle.infoDictionary
        guard let images = dict!["UILaunchImages"] as? [[String:AnyObject]] else{
            return nil
        }
        let scrsize=iScr.bounds.size
        for subdict in images {
            let size=CGSizeFromString(subdict["UILaunchImageSize"] as! String)
            if size.equalTo(scrsize) {
                return iimg( subdict["UILaunchImageName"] as? String)
            }
        }
        
        return nil
    }
    
    
    
    class func imgFromLayer(_ layer:CALayer)->UIImage{
        UIGraphicsBeginImageContextWithOptions(layer.size, false, 0)
        layer.render(in:UIGraphicsGetCurrentContext()!)
        let img:UIImage=UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return img
    }
    
    
    class func imgFromView(_ view:UIView)->UIImage{
        UIGraphicsBeginImageContextWithOptions(view.size, false, 0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)
        let img:UIImage=UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return img
    }
    
    func convertAndroidPointNine()->UIImage{
        UIGraphicsBeginImageContextWithOptions(CGSize(width:self.size.width-6, height:self.size.height-6), false, 0)
        let con:CGContext=UIGraphicsGetCurrentContext()!
        con.draw(self.cgImage!, in: CGRect(x:-3,y: -3,width: self.size.width, height:self.size.height))
        
        let img=UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!.stretch()
    }
    class func generateVideoImage(_ url:URL,cb:@escaping ((_ img:UIImage)->()))
    {
        let asset=AVURLAsset(url: url)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform=true
        
        let thumbTime = CMTimeMakeWithSeconds(0,30)
        
        let  handler:AVAssetImageGeneratorCompletionHandler = {( requestedTime,  im,  actualTime,  result,  error) in
            DispatchQueue.main.async {
                if (result != AVAssetImageGeneratorResult.succeeded) {
                    iPop.toast("couldn't generate thumbnail, error:\(error)")
                    return
                }
                let img = UIImage(cgImage: im!)
                cb(img)

            }
            
        }
        
        
        generator.maximumSize = CGSize(width:320, height:180)
        
        generator.generateCGImagesAsynchronously(forTimes: [NSValue(time:thumbTime)], completionHandler: handler)
        
    
    }
}


extension UIImageView{
    convenience init(frame:CGRect?=nil,img:UIImage?,radi:CGFloat=0,borderColor:UIColor?=nil,borderW:CGFloat=0){
        self.init(image:img)
        if let frame=frame{
            self.frame=frame
        }
        layer.cornerRadius=radi
        layer.masksToBounds=radi>0
        if let color=borderColor{
            layer.borderColor=color.cgColor
            layer.borderWidth=borderWidth
        }
        
    }
}
