
//
//  YFWebVC.swift
//  day-43-microblog
//
//  Created by apple on 15/12/6.
//  Copyright © 2015年 yf. All rights reserved.
//

import UIKit


class YFWebVC: UIViewController ,UIWebViewDelegate{
    
    lazy var wv:UIWebView={
        let w=UIWebView(frame: CGRect(x: 0, y: 0, width: self.view.w, height: self.view.h))
        w.delegate=self
        return w
    }()
    
    
    
    func webViewDidStartLoad(_ webView: UIWebView){
        iApp.isNetworkActivityIndicatorVisible=true
        iPop.showProg()
    }
    func webViewDidFinishLoad(_ webView: UIWebView){
        iApp.isNetworkActivityIndicatorVisible=false
        iPop.dismProg()
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error){
        iApp.isNetworkActivityIndicatorVisible=false
        iPop.dismProg()
    }
    

    
}
