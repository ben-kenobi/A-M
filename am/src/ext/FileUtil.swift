//
//  FileUtil.swift
//  EqApp
//
//  Created by apple on 16/9/7.
//  Copyright © 2016年 apple. All rights reserved.
//

import Foundation
class FileUtil{
    
    class func fileSizeAtPath(path:String)->Int64{
        var b:ObjCBool=false
        if(iFm.fileExists(atPath: path,isDirectory:&b)){
            if(b.boolValue){
                return try! iFm.attributesOfItem(atPath: path)[FileAttributeKey.size] as! Int64
            }
            else{
                var size:Int64=0
                let subpaths:[String] = iFm.subpaths(atPath: path) ?? []
                for file in subpaths{
                    size += try! iFm.attributesOfItem(atPath: (path as NSString).appendingPathComponent(file))[FileAttributeKey.size] as! Int64
                    
                }
                return size;
            }
        }
        return 0;
    }
    
    class func formatedFileSize2(size:Int64)->String{
        let strs = ["B","K","M","G","T"]
        var idx:Int=0
        var resul:Double = Double(size)
        while (idx<4&&resul>1000) {
            if(idx==0){
                resul=Double(size)/1000.0;
            }
            else{
                resul=resul/1000.0;
            }
            idx += 1
        }
        if(idx==0){
            return String(format: "%lld %@", size,strs[idx])
            
        }
        else{
            return String(format: "%.2f %@", resul,strs[idx])
        }
    }
    
    
    class func formatedFileSize(size:Int64)->String{
        
        let strs = ["B","K","M","G","T"]
        var idx:Int=0
        var resul:Double = Double(size)
        while (idx<4&&resul>1024) {
            if(idx==0){
                resul=Double(size)/1024.0;
            }
            else{
                resul=resul/1024.0;
            }
            idx += 1
        }
        if(idx==0){
            return String(format: "%lld %@", size,strs[idx])
            
        }
        else{
            return String(format: "%.2f %@", resul,strs[idx])
        }
    }
    
    class func cachePath()->String{
        
        return  NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
    }
    class func docPath()->String{
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
    class func tempPath()->String{
        return NSTemporaryDirectory();
    }
    
    class func clearFileAtPath(path:String){
        if iFm.fileExists(atPath:path){
            let files:[String] =  iFm.subpaths(atPath: path) ?? []
            for file in files{
                let apath = (path as NSString).appendingPathComponent(file)
                try! iFm.removeItem(atPath:apath)
            }
        }
    }
    
    
    class func newImgFile() ->String{
        return iConst.PNGDATESDF.string(from: Date())
    
    }
    class func newVideoFile() ->String{
        return iConst.MP4DATESDF.string(from: Date())
    }

}
