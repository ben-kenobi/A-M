

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
        
        if(children.count>1){
            //            viewController.navigationItem.leftBarButtonItem=UIBarButtonItem(img:UIImage(named: "back_pressed"),hlimg:UIImage(named: "back_nopress"), title: ""
            //           , tar: self, action: #selector(MainNavVC.back))
            viewController.navigationItem.leftBarButtonItem =
                UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.reply, target: self, action: #selector(MainNavVC.back))
            viewController.hidesBottomBarWhenPushed=true
        }else if(children.count==1){
            //            viewController.navigationItem.leftBarButtonItem=UIBarButtonItem(img:UIImage(named: "back_pressed"),hlimg:UIImage(named: "back_nopress"), title: homeTitle()
            //                , tar: self, action: #selector(MainNavVC.back))
            viewController.navigationItem.leftBarButtonItem =
                UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.reply, target: self, action: #selector(MainNavVC.back))
            viewController.hidesBottomBarWhenPushed=true
        }else if(children.count==0){
            //            viewController.navigationItem.leftBarButtonItem=UIBarButtonItem(img:UIImage(named: "back_pressed"),hlimg:UIImage(named: "back_nopress"), title: ""
            //                , tar: self, action: #selector(MainNavVC.back))
            viewController.navigationItem.leftBarButtonItem =
                UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.reply, target: self, action: #selector(MainNavVC.back))
            
            viewController.hidesBottomBarWhenPushed=true
        }
        let btn = viewController.navigationItem.leftBarButtonItem?.customView as? UIButton
        btn?.imageEdgeInsets=UIEdgeInsets(top: 0,  left: -20,  bottom: 0,  right: 20)
        super.pushViewController(viewController, animated: animated)
    }
    
    
    
    func homeTitle()->String{
        return ""
        //        if let  tit = self.children.first!.navigationItem.title{
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
        return children.count>1
        
    }
    
    
    @objc func back(){
        if(children.count>1){
            popViewController(animated: true)
        }else{
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    
    
    
    
}
