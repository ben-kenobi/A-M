
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
    
    class func requestImg(_ get:Bool,url:String,para:Any?,cb:((_ img:UIImage?)->())?,fail:((_ err:Error,_ resp:URLResponse?)->())?=nil){
        request(get, url: url, para: para, cb: { (data, resp) -> () in
            cb?(UIImage(data: data, scale: iScale))
            }, fail: fail)
    }
    
    class func requestJson(_ get:Bool,url:String,para:Any?,cb:((Any)->())?,fail:((_ err:Any,_ resp:URLResponse?)->())?=nil){
        request(get, url: url, para: para, cb: { (data, resp) -> () in
            do{
                cb?(try JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.allowFragments]))
            }catch{
                print(error)
                fail?( "\(error)", nil)
            }
            },fail: fail)
    }
    
    class func requestStr(_ get:Bool,url:String,para:Any?,cb:((_ str:String?)->())?,fail:((_ err:Error,_ resp:URLResponse?)->())?=nil){
        request(get, url: url, para: para, cb: { (data, resp) -> () in
            cb?( String(data: data, encoding: String.Encoding.utf8))
            }, fail: fail)
    }
    
    
    class func request(_ get:Bool,url:String,para:Any?,cb:((_ data:Data,_ resp:URLResponse?)->())?,fail:((_ err:Error,_ resp:URLResponse?)->())?=nil){
        let suc={
            (task:URLSessionDataTask,data:Any)->() in
            cb?(data as! Data, task.response)
        }
        let fail={
            (task:URLSessionDataTask?,err:Error)->() in
            fail?( err,  task?.response)
        }
        
        if(get){
            man.get(fullUrl(url), parameters: para, success: suc, failure: fail)
        }else{
            man.post(fullUrl(url), parameters: para, success: suc, failure: fail)
           
        }
    }
    
    class func upload(_ url:String,para:Any?,datas:[String:Data], cb:((_ data:Data,_ resp:URLResponse?)->())?,fail:((_ err:Error,_ resp:URLResponse?)->())?=nil){
        
        let suc={
            (task:URLSessionDataTask,data:Any)->() in
            cb?( data as! Data , task.response)
        }
        let fail={
            (task:URLSessionDataTask?,err:Error)->() in
            fail?( err,  task?.response)
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
    
    
    
    
    class func dict2str(_ dict:[String:Any]?)->String{
        if(nil==dict){
            return ""
        }
        var str:String=""
        for (k,v) in dict! {
            str+="\(k)=\(v)&"
        }
        
        return str == "" ? "" : (str as NSString).substring(to: str.len-1)
    }
    
    class func get(_ url:URL?,cache:Bool,cb:((_ data:Data?,_ resp:URLResponse?,_ err:Error?)->())?){
        guard let ur=url else{
            return
        }
        let cachepolicy = cache ? NSURLRequest.CachePolicy.useProtocolCachePolicy : NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        
        URLSession.shared.dataTask(with: URLRequest(url: ur,cachePolicy:cachepolicy,timeoutInterval:15 ), completionHandler:{ (data, resp, err) -> Void in
            DispatchQueue.main.async {
                cb?( data,resp,err)
            }
            
        }).resume()
    }
    
    class func post(_ url:URL?,body:String,cb:((_ data:Data?,_ resp:URLResponse?,_ err:Error?)->())?){
        guard let url=url else{
            return
        }
        var req=URLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 15)
        
        req.httpMethod="POST"
        
        req.httpBody=body.replacingPercentEscapes(using:String.Encoding(rawValue: UInt(4)))?.data(using: String.Encoding(rawValue: UInt(4)))
        URLSession.shared.dataTask(with: req, completionHandler:{ (data, resp, err) -> Void in
            DispatchQueue.main.async {
                cb?(data,resp,err)

            }
        }).resume()
        
    }
    
    class func synResponse(by url:URL)->URLResponse?{
        var resp:URLResponse? = nil
        var req=URLRequest(url: url)
        req.httpMethod = "HEAD"
        do{
            try NSURLConnection.sendSynchronousRequest(req, returning: &resp)
        }catch{
            resp = nil
        }
        return resp
    }
    class func contentLenBy(_ url:String)->Int64{
        return synResponse(by:URL(string: url)!)?.expectedContentLength ?? 0
    }
    class func mimeTypeBy(_ url:String)->String?{
        return synResponse(by:URL(string: url)!)?.mimeType
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
    class func showProg(_ msg:String?=nil){
//        SVProgressHUD.show(with: SVProgressHUDMaskType.black)
//        SVProgressHUD.setStatus(msg)

        SVProgressHUD.showProgress(-1, status: msg, maskType: SVProgressHUDMaskType.black)
    }
    class func dismProg(){
        SVProgressHUD.dismiss()
    }
    class func toast(_ msg:String){
//        frontestWindow().makeToast(msg)
        frontestWindow().makeToast(msg, duration: 1.2, position: nil, style:CSToastManager.sharedStyle())
    }
    class func toastOnMain(_ msg:String){
        DispatchQueue.main.async {
               frontestWindow().makeToast(msg, duration: 1.2, position: nil, style:CSToastManager.sharedStyle())
        }
    }

    
  
}
class iDialog{
    class func dialogWith(_ title:String?,msg:String?,actions:[UIAlertAction],vc:UIViewController){
        let ac = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        for action in actions{
            ac.addAction(action)
        }
        vc.present(ac, animated: true, completion: nil)
    }
}


class ALUtil{
    
    class func setImgFromALURL(_ alurl:URL,cb:@escaping((_ img:UIImage?)->())){
        let resultblock:ALAssetsLibraryAssetForURLResultBlock = {
            (myasset) in
            let rep:ALAssetRepresentation = myasset!.defaultRepresentation()
            let iref:CGImage = rep.fullResolutionImage().takeUnretainedValue()
            let image = UIImage(cgImage: iref)
            DispatchQueue.main.async {
                cb( image)

            }
         
        }
        
        let failureblock:ALAssetsLibraryAccessFailureBlock  = {(err) in
            print("load ALAssets fail")
        }
        let assetslibrary:ALAssetsLibrary = ALAssetsLibrary()
        assetslibrary.asset(for: alurl, resultBlock: resultblock, failureBlock: failureblock)
    }
}


class UploadUtil{
    
    
    //----multi--
    
    class func multiUpload(_ para:[String:String],contents:[String:String],toUrl:String,cb:((_ state:Int,_ obj:Any?,_ err:Error?,_ totalWritten:Int64?,_ totalExpectedToWritten:Int64?)->Void)?)->AFHTTPRequestOperation{
        let serializer = AFHTTPRequestSerializer()
        var err:NSError?=nil
        let request = serializer.multipartFormRequest(withMethod: "POST", urlString: toUrl, parameters: para, constructingBodyWith: { (data) in
            for (k,v) in contents{
                try! data.appendPart(withFileURL: iFUrl(v)!, name: k)
            }
            }, error: &err)
        
        let manager = AFHTTPRequestOperationManager()
        let operation:AFHTTPRequestOperation=manager.httpRequestOperation(with: request as URLRequest, success: { (operation, resp) in
            cb?( 0,resp, nil, nil, nil)
        }) { (operation, err) in
            cb?( -1,nil, err, nil, nil)

        }
        operation.setUploadProgressBlock { (written, totalwritten, totalExpectedToWritten) in
            cb?( 1,nil, nil, totalwritten, totalExpectedToWritten)

        }
        operation.start()
        
        return operation
        
        
    }
    
    
   
    
}


