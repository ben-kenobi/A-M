

//
//  CustTabBarItem.swift
//  day-43-microblog
//
//  Created by apple on 15/12/12.
//  Copyright © 2015年 yf. All rights reserved.
//

import UIKit

class CustTabBarItem: UITabBarItem {
    let badgeBgImg=iimg("more")
    override var badgeValue:String?{
        didSet{
            
            
            
            
//            var count:UInt32=0
//            let vars=class_copyIvarList(NSClassFromString("UITabBarItem"), &count)
//            for i in 0..<count{
//                let v=vars[Int(i)]
//                let val=valueForKeyPath(String(CString: ivar_getName(v), encoding: 4)!) ?? 0
//                print("\(String(format:"%s",ivar_getName(v)))=\(val!)")
//            }
            
            
            guard let  _=badgeValue else{
                return
            }
           
            guard let tabc = (value(forKeyPath: "target") as? UITabBarController) else{
                return
            }
            
                        
            for subv in tabc.tabBar.subviews{
                if subv.isKind(of:NSClassFromString("UITabBarButton")!){
                    for subv2 in subv.subviews{
                        if subv2.isKind(of:NSClassFromString("_UIBadgeView")!){
                            
                            for subv3 in subv2.subviews{
                                if subv3.isKind(of:NSClassFromString("_UIBadgeBackground")!){
                                    
                                    var count:UInt32=0
                                    
                                    let vars=class_copyIvarList(NSClassFromString("_UIBadgeBackground")!, &count)
                                    for i in 0..<count{
                                        let v=vars![Int(i)]
                                        let name=ivar_getName(v)
//                                        let type=ivar_getTypeEncoding(v)
//                                        print(String(CString: name, encoding: 4))
//                                        print(String(CString: type, encoding: 4))
                                        if let str=String(cString: name!, encoding: String.Encoding(rawValue: UInt(4))){
                                            if (str as NSString).isEqual(to: "_image") {
                                                subv3.setValue(badgeBgImg, forKeyPath: str)
                                            }
                                        }
                                    }
                                    
                                    
                                }
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
        }
    }

    
    override func value(forUndefinedKey key: String) -> Any? {
        return 0
    }
   
    
}
