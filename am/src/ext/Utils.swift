
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
import AssetsLibrary


class INet{
    static let man:AFHTTPSessionManager={
        let m=AFHTTPSessionManager()
        m.responseSerializer=AFHTTPResponseSerializer()
        //        m.securityPolicy.allowInvalidCertificates=true
        m.requestSerializer.timeoutInterval=5
        return m
    }()
    
    class func requestImg(get:Bool,url:String,para:AnyObject?,cb:((img:UIImage?)->())?,fail:((err:NSError,resp:NSURLResponse?)->())?=nil){
        request(get, url: url, para: para, cb: { (data, resp) -> () in
            cb?(img: UIImage(data: data, scale: iScale))
            },fail: fail)
    }
    
    class func requestJson(get:Bool,url:String,para:AnyObject?,cb:((AnyObject)->())?,fail:((err:AnyObject,resp:NSURLResponse?)->())?=nil){
        request(get, url: url, para: para, cb: { (data, resp) -> () in
            do{
                cb?(try NSJSONSerialization.JSONObjectWithData(data, options: [NSJSONReadingOptions.AllowFragments]))
            }catch{
                print(error)
                fail?(err: "\(error)",resp: nil)
            }
            },fail: fail)
    }
    
    class func requestStr(get:Bool,url:String,para:AnyObject?,cb:((str:String?)->())?,fail:((err:NSError,resp:NSURLResponse?)->())?=nil){
        request(get, url: url, para: para, cb: { (data, resp) -> () in
            cb?(str: String(data: data, encoding: 4))
            },fail: fail)
    }
    
    
    class func request(get:Bool,url:String,para:AnyObject?,cb:((data:NSData,resp:NSURLResponse?)->())?,fail:((err:NSError,resp:NSURLResponse?)->())?=nil){
        let suc={
            (task:NSURLSessionDataTask,data:AnyObject)->() in
            cb?(data: data as! NSData,resp: task.response)
        }
        let fail={
            (task:NSURLSessionDataTask?,err:NSError)->() in
            fail?(err: err, resp: task?.response)
        }
        
        if(get){
            man.GET(fullUrl(url), parameters: para, success: suc, failure: fail)
        }else{
            man.POST(fullUrl(url), parameters: para, success: suc, failure: fail)
           
        }
    }
    
    class func upload(url:String,para:AnyObject?,datas:[String:NSData], cb:((data:NSData,resp:NSURLResponse?)->())?,fail:((err:NSError,resp:NSURLResponse?)->())?=nil){
        
        let suc={
            (task:NSURLSessionDataTask,data:AnyObject)->() in
            cb?(data: data as! NSData,resp: task.response)
        }
        let fail={
            (task:NSURLSessionDataTask?,err:NSError)->() in
            fail?(err: err, resp: task?.response)
        }
        
        man.POST(url, parameters: para, constructingBodyWithBlock: { (formdata) -> Void in
            for (k,v) in datas{
                formdata.appendPartWithFormData(v, name: k)
            }
            }, success: suc, failure: fail)
        

    }
    
    class func fullUrl(url:String)->String{
        if (url.hasPrefix("http://")||url.hasPrefix("https://")) {
            return url;
        }
        return String(format: "%@%@", iBaseURL,url)
    }
    
    
    
    
    class func dict2str(dict:[String:AnyObject]?)->String{
        if(nil==dict){
            return ""
        }
        var str:String=""
        for (k,v) in dict! {
            str+="\(k)=\(v)&"
        }
        
        return str == "" ? "" : (str as NSString).substringToIndex(str.len-1)
    }
    
    class func get(url:NSURL?,cache:Bool,cb:((data:NSData?,resp:NSURLResponse?,err:NSError?)->())?){
        guard let ur=url else{
            return
        }
        let cachepolicy = cache ? NSURLRequestCachePolicy.UseProtocolCachePolicy : NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        
        NSURLSession.sharedSession().dataTaskWithRequest(NSURLRequest(URL: ur,cachePolicy:cachepolicy,timeoutInterval:15 ), completionHandler:{ (data, resp, err) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                cb?(data: data,resp:resp,err:err)
            })
            
        }).resume()
    }
    
    class func post(url:NSURL?,body:String,cb:((data:NSData?,resp:NSURLResponse?,err:NSError?)->())?){
        guard let ur=url else{
            return
        }
        let req=NSMutableURLRequest(URL: ur,cachePolicy:NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData ,timeoutInterval: 15)
        req.HTTPMethod="POST"
        
        req.HTTPBody=body.stringByReplacingPercentEscapesUsingEncoding(4)?.dataUsingEncoding(4)
        NSURLSession.sharedSession().dataTaskWithRequest(req, completionHandler:{ (data, resp, err) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                cb?(data: data,resp: resp,err: err)
            })
        }).resume()
        
    }
    
    class func synResponseByURL(url:NSURL)->NSURLResponse?{
        var resp:NSURLResponse? = nil
        let req=NSMutableURLRequest(URL: url)
        req.HTTPMethod = "HEAD"
        do{
            try NSURLConnection.sendSynchronousRequest(req, returningResponse: &resp)
        }catch{
            resp = nil
        }
        return resp
    }
    class func contentLenBy(url:String)->Int64{
        return synResponseByURL(NSURL(string: url)!)?.expectedContentLength ?? 0
    }
    class func mimeTypeBy(url:String)->String?{
        return synResponseByURL(NSURL(string: url)!)?.MIMEType
    }
    
}


class iFileUtil{
    class func cachePath()->String{
        return NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).first!
    }
    
    class func docPath()->String{
        return NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first!
    }
    
    class func tempPath()->String {
        return NSTemporaryDirectory()
    }
}

class iPop{
    class func showMsg(msg:String){
        SVProgressHUD.showInfoWithStatus(msg)
    }
    class func showSuc(msg:String){
        SVProgressHUD.showSuccessWithStatus(msg)
    }
    class func showError(msg:String){
        SVProgressHUD.showErrorWithStatus(msg)
    }
    class func showProg(){
        SVProgressHUD.showWithMaskType(SVProgressHUDMaskType.Black)
    }
    class func dismProg(){
        SVProgressHUD.dismiss()
    }
    class func toast(msg:String){
//        iApp.windows[iApp.windows.count-1].makeToast(msg)
        iApp.windows[iApp.windows.count-1].makeToast(msg, duration: 1.2, position: nil, style:CSToastManager.sharedStyle())
    }
    
  
}
class iDialog{
    class func dialogWith(title:String?,msg:String?,actions:[UIAlertAction],vc:UIViewController){
        let ac = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        for action in actions{
            ac.addAction(action)
        }
        vc.presentViewController(ac, animated: true, completion: nil)
    }
}


class ALUtil{
    
    class func setImgFromALURL(alurl:NSURL,cb:((img:UIImage?)->())){
        let resultblock:ALAssetsLibraryAssetForURLResultBlock = {
            (myasset) in
            let rep:ALAssetRepresentation = myasset.defaultRepresentation()
            let iref:CGImageRef = rep.fullResolutionImage().takeUnretainedValue()
            let image = UIImage(CGImage: iref)
            dispatch_async(dispatch_get_main_queue(), {
                cb(img: image)
            })
        }
        
        let failureblock:ALAssetsLibraryAccessFailureBlock  = {(err) in
            print("load ALAssets fail")
        }
        let assetslibrary:ALAssetsLibrary = ALAssetsLibrary()
        assetslibrary.assetForURL(alurl, resultBlock: resultblock, failureBlock: failureblock)
    }
}


class UploadUtil{
    
    
    //----multi--
    
    class func multiUpload(para:[String:String],contents:[String:String],toUrl:String,cb:((state:Int,obj:AnyObject?,err:NSError?,totalWritten:Int64?,totalExpectedToWritten:Int64?)->Void)?)->AFHTTPRequestOperation{
        let serializer = AFHTTPRequestSerializer()
        let request = serializer.multipartFormRequestWithMethod("POST", URLString: toUrl, parameters: para) { (data) in
            for (k,v) in contents{
                try! data.appendPartWithFileURL(NSURL(fileURLWithPath:v), name: k)
                
            }
        }
        let manager = AFHTTPRequestOperationManager()
        let operation:AFHTTPRequestOperation=manager.HTTPRequestOperationWithRequest(request, success: { (operation, resp) in
            cb?(state: 0,obj:resp,err: nil,totalWritten: nil,totalExpectedToWritten: nil)
        }) { (operation, err) in
            cb?(state: -1,obj:nil,err: err,totalWritten: nil,totalExpectedToWritten: nil)

        }
        operation.setUploadProgressBlock { (written, totalwritten, totalExpectedToWritten) in
            cb?(state: 1,obj:nil,err: nil,totalWritten: totalwritten,totalExpectedToWritten: totalExpectedToWritten)

        }
        operation.start()
        
        return operation
        
        
    }
    
    
   
    
}


