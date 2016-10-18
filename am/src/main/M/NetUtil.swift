//
//  NetUtil.swift
//  anquanguanli
//
//  Created by apple on 16/3/21.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class NetUtil {
    class func serverIP()->String{
        
        if let val = iPref()?.string(forKey: "server_ip"){
            return  val
        }
        return iConst.defServerIp
    }
    class func serverPref()->String{
    
        return iConst.defHttpPref + serverIP() + "/"
    }
    class func setServerIP(_ ip:String){
        iPref()?.set(ip, forKey: "server_ip")
        iPref()?.synchronize()
    }
    class func fullUrl(_ url:String)->String{
        if url.hasPrefix("http://") || url.hasPrefix("https://"){
            return url
        }
        return serverPref()+url
    }
    
    
    class func netWorkAvailable()->Bool{
        let reachability = Reachability.forInternetConnection()
        let networkStatus: Int = reachability!.currentReachabilityStatus().rawValue
        return networkStatus != 0
        
    }
    
    class func netWorkStatus()->Int{
        let reachability = Reachability.forInternetConnection()
        //        reachability.startNotifier()
        return reachability!.currentReachabilityStatus().rawValue
    }
    
    class func commonCheck()->Bool{
        if !netWorkAvailable(){
            iPop.toast("网络未连接，请检查")
            return false
        }
        if serverPref()==""{
            iPop.toast("服务IP和端口为空！请重新设置")
            return false
        }
        return true
    }
    
    
    class func commonRequestJson(_ get:Bool,path:String,para:AnyObject?,succode:[String],cb:((AnyObject,Int)->())?){
        if !commonCheck(){
            return
        }
        let url = fullUrl(path).urlEncoded()
        iPop.showProg()
        INet.requestJson(get, url: url, para: para, cb: { (data) -> () in
            iPop.dismProg()
            guard let _=cb else{
                return
            }
            
            if let status = data["status"] as? String{
                if succode.contains(status){

                    cb?(data,succode.index(of: status)!)
                }else{
                    
                    iPop.toast(data["errmsg"]==nil ? "未知错误":data["errmsg"] as! String)
                }
            }
            
            
            
            }) { (err, resp) -> () in
                iPop.dismProg()
                iPop.toast("请求失败 \(err)")
        }
    }
    
  
    
    class func commonRequestStr(_ get:Bool,path:String,para:AnyObject?,cb:((String?)->())?){
        if !commonCheck(){
            return
        }
        let url = fullUrl(path).urlEncoded()
        iPop.showProg()
        INet.requestStr(get, url: url, para: para, cb: { (data) -> () in
            iPop.dismProg()
            guard let _=cb else{
                return
            }
            
            cb?(data)
            
            }
            
            ) { (err, resp) -> () in
                iPop.dismProg()
                iPop.toast("请求失败 \(err)")
        }
    }
    
    
    class func commonRequest(_ get:Bool,path:String,para:AnyObject?,cb:((_ suc:Bool)->())?){
        if !commonCheck(){
            return
        }
        let url = fullUrl(path).urlEncoded()
        iPop.showProg()
        INet.request(get, url: url, para: para,cb: { (data, resp) in
            iPop.dismProg()
            cb?(suc: true)
            },fail: {(err,resp) in
                iPop.dismProg()
                cb?(suc: true)
        })
        
    }
    
}
