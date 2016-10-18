
//
//  Utils.swift
//  day-43-microblog
//
//  Created by apple on 15/12/5.
//  Copyright © 2015年 yf. All rights reserved.
//

import UIKit
//import AFNetworking
//import SVProgressHUD


class INet{
    static let man:AFHTTPSessionManager={
        let m=AFHTTPSessionManager()
        m.responseSerializer=AFHTTPResponseSerializer()
        //        m.securityPolicy.allowInvalidCertificates=true
        return m
    }()
    
    class func requestImg(_ get:Bool,url:String,para:AnyObject?,cb:((_ img:UIImage?)->())?,fail:((_ err:NSError,_ resp:URLResponse?)->())?=nil){
        request(get, url: url, para: para, cb: { (data, resp) -> () in
            cb?(img: UIImage(data: data, scale: iScale))
            },fail: fail)
    }
    
    class func requestJson(_ get:Bool,url:String,para:AnyObject?,cb:((AnyObject)->())?,fail:((_ err:AnyObject,_ resp:URLResponse?)->())?=nil){
        request(get, url: url, para: para, cb: { (data, resp) -> () in
            do{
                cb?(try JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.allowFragments]))
            }catch{
                print(error)
                fail?("\(error)" as AnyObject,nil)
            }
            },fail: fail)
    }
    
    class func requestStr(_ get:Bool,url:String,para:AnyObject?,cb:((_ str:String?)->())?,fail:((_ err:NSError,_ resp:URLResponse?)->())?=nil){
        request(get, url: url, para: para, cb: { (data, resp) -> () in
            cb?(String(data: data, encoding: String.Encoding(rawValue: UInt(4))))
            },fail: fail)
    }
    
    
    class func request(_ get:Bool,url:String,para:AnyObject?,cb:((_ data:Data,_ resp:URLResponse?)->())?,fail:((_ err:NSError,_ resp:URLResponse?)->())?=nil){
        let suc={
            (task:URLSessionDataTask,data:AnyObject)->() in
            cb?(data as! Data,task.response)
        }
        let fail={
            (task:URLSessionDataTask?,err:NSError)->() in
            fail?(err, task?.response)
        }
        
        if(get){
            man.get(fullUrl(url), parameters: para, success: suc, failure: fail)
        }else{
            man.post(fullUrl(url), parameters: para, success: suc, failure: fail)
        }
    }
    
    class func upload(_ url:String,para:AnyObject?,datas:[String:Data], cb:((_ data:Data,_ resp:URLResponse?)->())?,fail:((_ err:NSError,_ resp:URLResponse?)->())?=nil){
        
        let suc={
            (task:URLSessionDataTask,data:AnyObject)->() in
            cb?(data as! Data,task.response)
        }
        let fail={
            (task:URLSessionDataTask?,err:NSError)->() in
            fail?(err, task?.response)
        }
        
        man.post(url, parameters: para, constructingBodyWith: { (formdata) -> Void in
            for (k,v) in datas{
                formdata.appendPart(withForm: v, name: k)
            }
            }, success: suc, failure: fail)
    }
    
    class func fullUrl(_ url:String)->String{
        if (url.hasPrefix("http://")||url.hasPrefix("https://")) {
            return url;
        }
        return String(format: "%@%@", iBaseURL,url)
    }
    
    
    
    
    class func dict2str(_ dict:[String:AnyObject]?)->String{
        if(nil==dict){
            return ""
        }
        var str:String=""
        for (k,v) in dict! {
            str+="\(k)=\(v)&"
        }
        
        return str == "" ? "" : (str as NSString).substring(to: str.len-1)
    }
    
    class func get(_ url:URL?,cache:Bool,cb:((_ data:Data?,_ resp:URLResponse?,_ err:NSError?)->())?){
        guard let ur=url else{
            return
        }
        let cachepolicy = cache ? NSURLRequest.CachePolicy.useProtocolCachePolicy : NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        
        URLSession.shared.dataTask(with: URLRequest(url: ur,cachePolicy:cachepolicy,timeoutInterval:15 ), completionHandler:{ (data, resp, err) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                cb?(data,resp,err)
            })
            
        }).resume()
    }
    
    class func post(_ url:URL?,body:String,cb:((_ data:Data?,_ resp:URLResponse?,_ err:NSError?)->())?){
        guard let ur=url else{
            return
        }
        let req=NSMutableURLRequest(url: ur,cachePolicy:NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData ,timeoutInterval: 15)
        req.httpMethod="POST"
        
        req.httpBody=body.replacingPercentEscapes(using: String.Encoding(rawValue: UInt(4)))?.data(using: String.Encoding(rawValue: UInt(4)))
        URLSession.shared.dataTask(with: req, completionHandler:{ (data, resp, err) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                cb?(data,resp,err)
            })
        }).resume()
        
    }
    
  
    
}


class iFileUtil{
    class func cachePath()->String{
        return NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
    }
    
    class func docPath()->String{
        return NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
    }
    
    class func tempPath()->String {
        return NSTemporaryDirectory()
    }
}

class iPop{
    class func showMsg(_ msg:String){
        SVProgressHUD.showInfo(withStatus: msg)
    }
    class func showSuc(_ msg:String){
        SVProgressHUD.showSuccess(withStatus: msg)
    }
    class func showError(_ msg:String){
        SVProgressHUD.showError(withStatus: msg)
    }
    class func showProg(){
        SVProgressHUD.show()
    }
    class func dismProg(){
        SVProgressHUD.dismiss()
    }
    class func toast(_ msg:String){
//        iApp.windows[iApp.windows.count-1].makeToast(msg)
        iApp.windows[iApp.windows.count-1].makeToast(msg, duration: 1.2, position: nil, style:CSToastManager.sharedStyle())
        
    }
}



