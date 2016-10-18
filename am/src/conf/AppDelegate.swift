//
//  AppDelegate.swift
//  day-43-microblog
//
//  Created by apple on 15/12/3.
//  Copyright © 2015年 yf. All rights reserved.
//

import UIKit


let updateRootVCNoti="updateRootVCNoti"
let versionKey="CFBundleShortVersionString"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var accessKey:String?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window=UIWindow(frame: UIScreen.main.bounds)
        setRootVC()
        window!.makeKeyAndVisible()
        iApp.isStatusBarHidden=false
        window?.backgroundColor=UIColor.white
        
        iNotiCenter.addObserver(self, selector: #selector(AppDelegate.setRootVC), name: updateRootVCNoti, object: nil)
        
        return true
    }
    
    func setRootVC(){
        
        UITabBar.appearance().isTranslucent=false
        UINavigationBar.appearance().isTranslucent=false
        UINavigationBar.appearance().titleTextAttributes=[NSFontAttributeName:ibFont(19),NSForegroundColorAttributeName:UIColor.orange]
        //        UINavigationBar.appearance().tintColor=iGlobalGreen
        //        UINavigationBar.appearance().setBackgroundImage(iimg("login_bg"), forBarMetrics: UIBarMetrics.Default)
        
        
        
        
        
        guard let win = window else{
            return
        }
        
        var img:UIImage?
        if let vc=win.rootViewController{
            img=UIImage.imgFromLayer(vc.view.layer)
        }
        let dict = iRes4Dic("conf.plist") as! [String:String]
        if newVersion(){
            win.rootViewController=iVCFromStr( dict["introVC"]!)
            saveVersion(curVersion())
            
        }else if !UserInfo.isLogin(){
            win.rootViewController=iVCFromStr( dict["loginVC"]!)
        }else if !UserInfo.hasWelcomed(){
            win.rootViewController=iVCFromStr(dict["welcomeVC"]!)
            UserInfo.welcomed(true)
        }else   {
            win.rootViewController=iVCFromStr( dict["rootVC"]!)
        }
        
        if let img=img {
            let iv:UIImageView=UIImageView(image: img)
            win.addSubview(iv)
            UIView.animate(withDuration: 1, animations: { () -> Void in
                iv.alpha=0.1
                iv.transform=CGAffineTransform(scaleX: 2, y: 2)
                }, completion: { (b) -> Void in
                    iv.removeFromSuperview()
            })
        }
        
    }
    
    
    
        
    
    deinit{
        iNotiCenter.removeObserver(self)
    }
    
    
    
    
    func newVersion()->Bool{
        
        return curVersion().compare(savedVersion() ?? "")==ComparisonResult.orderedDescending
        
    }
    
    
    func curVersion()->String{
        return iInfoDict[versionKey] as! String
    }
    
    func savedVersion()->String?{
        return iPref(nil)?.string(forKey: versionKey)
    }
    
    func saveVersion(_ ver:String){
        iPref(nil)?.set(ver, forKey: versionKey)
        iPref(nil)?.synchronize()
    }
    
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}
