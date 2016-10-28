

//
//  MainNavVC.swift
//  day-43-microblog
//
//  Created by apple on 15/12/5.
//  Copyright © 2015年 yf. All rights reserved.
//

import UIKit

class MainNavVC: UINavigationController,UIGestureRecognizerDelegate {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate=self
        navigationBar.setBackgroundImage(iimg(iConst.iGlobalGreen), for: UIBarMetrics.default)
        
    }
    
    
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if(childViewControllers.count>1){
            //            viewController.navigationItem.leftBarButtonItem=UIBarButtonItem(img:UIImage(named: "back_pressed"),hlimg:UIImage(named: "back_nopress"), title: ""
            //           , tar: self, action: #selector(MainNavVC.back))
            viewController.navigationItem.leftBarButtonItem =
                UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.reply, target: self, action: #selector(MainNavVC.back))
            viewController.hidesBottomBarWhenPushed=true
        }else if(childViewControllers.count==1){
            //            viewController.navigationItem.leftBarButtonItem=UIBarButtonItem(img:UIImage(named: "back_pressed"),hlimg:UIImage(named: "back_nopress"), title: homeTitle()
            //                , tar: self, action: #selector(MainNavVC.back))
            viewController.navigationItem.leftBarButtonItem =
                UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.reply, target: self, action: #selector(MainNavVC.back))
            viewController.hidesBottomBarWhenPushed=true
        }else if(childViewControllers.count==0){
            //            viewController.navigationItem.leftBarButtonItem=UIBarButtonItem(img:UIImage(named: "back_pressed"),hlimg:UIImage(named: "back_nopress"), title: ""
            //                , tar: self, action: #selector(MainNavVC.back))
            viewController.navigationItem.leftBarButtonItem =
                UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.reply, target: self, action: #selector(MainNavVC.back))
            
            viewController.hidesBottomBarWhenPushed=true
        }
        let btn = viewController.navigationItem.leftBarButtonItem?.customView as? UIButton
        btn?.imageEdgeInsets=UIEdgeInsetsMake(0,  -20,  0,  20)
        super.pushViewController(viewController, animated: animated)
    }
    
    
    
    func homeTitle()->String{
        return ""
        //        if let  tit = self.childViewControllers.first!.navigationItem.title{
        //            if tit.len>3 {
        //                return "back"
        //            }else{
        //                return tit
        //            }
        //        }else{
        //            return "back"
        //        }
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return childViewControllers.count>1
        
    }
    
    
    func back(){
        if(childViewControllers.count>1){
            popViewController(animated: true)
        }else{
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    
    
    
    
}
