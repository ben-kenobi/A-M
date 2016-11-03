//
//  FileUtil.swift
//  EqApp
//
//  Created by apple on 16/9/7.
//  Copyright © 2016年 apple. All rights reserved.
//

import Foundation
class FileUtil{
    
    class func systemFreeSize()->Int64{
        return (try! iFm.attributesOfFileSystem(forPath: NSHomeDirectory())[FileAttributeKey.systemFreeSize] as! NSNumber).int64Value
    }
    class func systemUsageSize()->Int64{
        return systemSize()-systemFreeSize()
    }
    class func systemSize()->Int64{
        return (try! iFm.attributesOfFileSystem(forPath: NSHomeDirectory())[FileAttributeKey.systemSize] as! NSNumber).int64Value
    }
    class func sysUsageDescription()->(String,Float){
        let usedsize = systemUsageSize()
        let totalsize = systemSize()
        let used = formatedFileSize2(usedsize)
        let total = formatedFileSize2(totalsize)
        let percent = Float(usedsize)/Float(totalsize)
        let percentstr = String(format: "%.2f %%", percent*100)
        return ("已使用： \(percentstr)\n\(used) / \(total)",percent)
        
    }
    
    class func copy2ClipBoard(_ str:String){
        UIPasteboard.general.string=str
    }
    
    class func fileSizeAtPath(path:String)->(Int64,Int){
        var b:ObjCBool=false
        if(iFm.fileExists(atPath: path,isDirectory:&b)){
            if(!b.boolValue){
                 let num  = (try? iFm.attributesOfItem(atPath: path)[FileAttributeKey.size] as! NSNumber)
                if let num = num {
                    return (num.int64Value,1)
                }
                return (0,1)
            }else{
                var size:Int64=0
                var count=0
                let subpaths:[String] = iFm.subpaths(atPath: path) ?? []
                for file in subpaths{
                    let path = (path as NSString).appendingPathComponent(file)
                    if iFm.fileExists(atPath: path, isDirectory: &b) && !b.boolValue{
                        count += 1
                        let num = try? iFm.attributesOfItem(atPath:path)[FileAttributeKey.size] as! NSNumber
                        if let num = num{
                            size += num.int64Value
                        }
                    }
                    
                }
                return (size,count)
            }
        }
        return (0,0);

    }
    
    static func fileDetailDescription(_ path:String,cb:@escaping ((_ str:String)->Void)){
        cb( "位置:  \(path)\n大小:  ....\n修改时间:  \(modiTime(path).timeFM())")
        DispatchQueue.global().async {
            let str = "位置:  \(path)\n大小:  \(fileSizePattern(path))\n修改时间:  \(modiTime(path).timeFM())"
            DispatchQueue.main.async {
                cb(str)
            }
        }
    }
    
    
    static func fullPath(_ name:String,_ dir:String)->String{
        let separator =  dir == "/" ? "" : "/"
        return dir + separator + name
    }
    
    static func fileDetailDescription(_ path:String)->String{
        return "位置:  \(path)\n大小:  \(fileSizePattern(path))\n修改时间:  \(modiTime(path).timeFM())"
    }
    static func modiTime(_ path:String)->Date{
        let date  = try? iFm.attributesOfItem(atPath:path)[FileAttributeKey.modificationDate] as! Date
        if let date = date{
            return date
        }
        return Date(timeIntervalSince1970: 0)
        
    }
    static func fileSizePattern(_ path:String)->String{
        return fileSizePattern(fileSizeAtPath(path: path), dir: isDir(path))
    }
    static func fileSizePattern(_ size:(Int64,Int),dir:Bool)->String{
        var str = formatedFileSize(size.0)
        
        if size.0 > 1000{
            str += "   ( \(formatNum(size.0)) B )  "
        }
        if dir{
            str += " ( 共 \(formatNum(Int64(size.1))) 个文件 )"
        }
        return str
    }
    static func formatNum(_ size:Int64)->String{
        var a = size, b:Int64 = 0
        
        b = a%1000
        var str = "\(b)"
        
        while a>1000{
            
            a /= 1000
            b = a%1000
            str = "\(b),\(str)"
        }
        return str
    }
    
    class func formatedFileSize2(_ size:Int64)->String{
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
    
    
    class func formatedFileSize(_ size:Int64)->String{
        
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
    
    
    
    // getBackupDir
    static func  getBackupDir() -> String{
        let backupDir = fullPath(iConst.BACKUPDIR_SUF,docPath())
        _=mkDir(docPath(), iConst.BACKUPDIR_SUF)
        return backupDir
    }
    
    // get_backupFile
    static func  getBackupFile(_ platform:String)->String {
        let backup = fullPath(platform+iConst.BACKUPFILE_SUF+Date().timeFM5(), getBackupDir())
        return backup;
    }
    
    // get_backupFile
    static func  getBackupFile(_ parent:String,_ platform:String)->String {
        let backup = fullPath(platform+iConst.BACKUPFILE_SUF+"_"+Date().timeFM5(),parent)
        return backup;
    }
    
    static func getNonexistBackupFile(_ parent:String, _ platform:String)->String{
        var idx:Int = 0
        let dest = getBackupFile(parent,platform)
        var file = dest
        while iFm.fileExists(atPath: file){
            file = dest+"(dup_\(idx))"
            idx += 1
        }
        return file
    }
    
    // getUnexistFile
    static func getUnexistFile(_ dest:String) ->String{
        var file = dest
        var idx:Int = 0
        while iFm.fileExists(atPath: file){
            file = dest+"(dup_\(idx))"
            idx += 1
        }
        return file
    }


}
