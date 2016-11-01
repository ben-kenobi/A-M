//
//  FileSystemUtil.swift
//  am
//
//  Created by apple on 16/10/26.
//  Copyright © 2016年 apple. All rights reserved.
//

import Foundation

extension FileUtil{
    
    @nonobjc static let extensionIconMap:[String:(String,Int)] = initExtensions()
    
    
    
    
    
    // mkDir -- success:1  fail:0  exists:-1
    static func  mkDir(_ parent:String, _ dirname:String) ->Int{
        if !isReadableDir(parent) || empty(dirname){
            return 0
        }
        let path = fullPath(dirname, parent)
        if iFm.fileExists(atPath: path){
            return -1
        }
        
        do {
            try iFm.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            return 1
        } catch  {
            return 0
        }
        
    }
    // createNewFile -- success:1  fail:0  exists:-1
    static func  createNewFile(_ parent:String, _ filename:String)->Int {
        if !isReadableDir(parent) || empty(filename){
            return 0
        }
        let path = fullPath(filename, parent)

        if iFm.fileExists(atPath: path){
            return -1
        }
        
        return iFm.createFile(atPath: path, contents: nil, attributes: nil) ? 1 : 0
    
    }

    
    //renameFile--  -2:notchanged , 1:success , 0:fail , -1:conflict
    static func renameFile(_ file:String,toname:String)->Int{
        if (file as NSString).lastPathComponent.equalIgnoreCase(toname){
            return -2
        }
        let parent =  (file as NSString).deletingLastPathComponent
        if !iFm.isWritableFile(atPath:parent) || !iFm.isWritableFile(atPath: file){
            return 0
        }
        
        let newfile = FileUtil.fullPath(toname, parent)
        
        if iFm.fileExists(atPath: newfile){
            return -1
        }
        let newparent = (newfile as NSString).deletingLastPathComponent
        var result = 1
        if !iFm.fileExists(atPath: newparent){
            do{
                try iFm.createDirectory(atPath: newparent, withIntermediateDirectories: true, attributes: nil)
            }catch{
                result=0
            }
        }
        if result == 1{
            do{
                try iFm.moveItem(atPath: file, toPath: newfile)
                try!iFm.setAttributes([FileAttributeKey.modificationDate:Date()], ofItemAtPath: newfile)
            }catch{
                result = 0
            }
        }
        return result
        
        
    }
    
    
    
    
    
    static func  getFileType(_ file:String) ->Int{
        return isDir(file) ? 0 : isFile(file) ? 1 : 2
    }
    
    static func  compareFileType(_ left:String,_ right:String)->Int {
        return getFileType(left) - getFileType(right)
    }
    
    
    static func isDir(_ path:String)->Bool{
        var b = ObjCBool.init(false)
        if iFm.fileExists(atPath: path, isDirectory: &b) && b.boolValue {
            return true
        }
        return false
    }
    static func isFile(_ path:String)->Bool{
        var b = ObjCBool.init(false)
        if iFm.fileExists(atPath: path, isDirectory: &b) && !b.boolValue {
            return true
        }
        return false
    }
    static func isInvalid(_ path:String)->Bool{
        return !iFm.fileExists(atPath: path)
    }
    
    static func isReadableFile(_ path:String)->Bool{
        var b = ObjCBool.init(false)
        if iFm.fileExists(atPath: path, isDirectory: &b) && !b.boolValue && iFm.isReadableFile(atPath: path){
            return true
        }
        return false
    }

    
    static func isReadableDir(_ path:String)->Bool{
        
        var b = ObjCBool.init(false)
        if iFm.fileExists(atPath: path, isDirectory: &b) && b.boolValue && iFm.isReadableFile(atPath: path){
            return true
        }
        return false
    }
    static func isWritableDir(_ path:String)->Bool{
        
        var b = ObjCBool.init(false)
        if iFm.fileExists(atPath: path, isDirectory: &b) && b.boolValue && iFm.isWritableFile(atPath: path){
            return true
        }
        return false
    }
    
    
    // hidden: prefix With"." , alpha=0.5
    // can not wirite : indicator orange
    // can not read : indicator red
    static func icon(_ name:String,dir:String,cell:FileCell){
        let alpha:CGFloat = name.hasPrefix(".") ? 0.5:1
        cell.alpha=alpha
        cell.name.text=name
        let path = dir + "/" + name
        var b = ObjCBool.init(false)
        if !iFm.fileExists(atPath: path, isDirectory: &b){
            cell.icon.image=iimg("icon_error")
            cell.indicator.isHidden=true
            return
        }
        
        let readable = iFm.isReadableFile(atPath: path)
        let writeable = iFm.isWritableFile(atPath: path)
        if readable{
            if writeable{
                cell.indicator.isHidden=true
            }else{
                cell.indicator.isHidden=false
                cell.indicator.backgroundColor=iColor(0xffddbb11)
            }
        }else{
           cell.indicator.isHidden=false
            cell.indicator.backgroundColor=iColor(0xffdd2255)
        }
        
        if b.boolValue {
            var count = 0
            if iFm.isReadableFile(atPath: path){
                count = try! iFm.contentsOfDirectory(atPath: path).count
            }
            if count <= 0{
                cell.icon.image = iimg("icon_dir_empty")
            }else{
                cell.icon.image = iimg("icon_dir_stuffed")
            }
        
        }else if readable{
            let ext = (name as NSString).pathExtension.lowercased()
            let tup:(String,Int)? = extensionIconMap[ext]
            if let tup = tup {
                cell.icon.image=iimg(tup.0)
            }else{
                cell.icon.image=iimg("icon_file1")

            }
        }else{
            cell.icon.image=iimg("icon_system")
        }
        
    }
    
    static func initExtensions()->[String:(String,Int)]{
        var extensionIconMap = [String:(String,Int)]()
        //------------img-------------------------------
        extensionIconMap["jpg"]=("icon_jpg",101)
        extensionIconMap["jpeg"]=("icon_jpg",102)
        extensionIconMap["gif"]=("icon_gif",103)
        extensionIconMap["png"]=("icon_png",104)
        extensionIconMap["bmp"]=("icon_bmp",105)
        extensionIconMap["wbmp"]=("icon_bmp",106)
        
        //------------music-------------------------------
        let  music = "icon_music"
        extensionIconMap["mp3"]=(music,301)
        extensionIconMap["m4a"]=(music,302)
        extensionIconMap["wav"]=(music,303)
        extensionIconMap["amr"]=(music,304)
        extensionIconMap["awb"]=(music,305)
        extensionIconMap["aac"]=(music,306)
        extensionIconMap["flac"]=(music,307)
        extensionIconMap["mid"]=(music,308)
        extensionIconMap["midi"]=(music,309)
        extensionIconMap["xmf"]=(music,310)
        extensionIconMap["rttt1"]=(music,311)
        extensionIconMap["rtx"]=(music,312)
        extensionIconMap["ota"]=(music,313)
        extensionIconMap["wma"]=(music,314)
        extensionIconMap["ra"]=(music,315)
        extensionIconMap["mka"]=(music,316)
        extensionIconMap["m3u"]=(music,317)
        extensionIconMap["pls"]=(music,318)
        
        //------------video-------------------------------
        let video = "icon_video"
        extensionIconMap["mpeg"]=(video,201)
        extensionIconMap["mp4"]=(video,202)
        extensionIconMap["mov"]=(video,203)
        extensionIconMap["m4v"]=(video,204)
        extensionIconMap["3gp"]=(video,205)
        extensionIconMap["3gpp"]=(video,206)
        extensionIconMap["3g2"]=(video,207)
        extensionIconMap["3gpp2"]=(video,208)
        extensionIconMap["avi"]=(video,209)
        extensionIconMap["divx"]=(video,210)
        extensionIconMap["wmv"]=(video,211)
        extensionIconMap["asf"]=(video,212)
        extensionIconMap["flv"]=(video,213)
        extensionIconMap["mkv"]=(video,214)
        extensionIconMap["mpg"]=(video,215)
        extensionIconMap["rmvb"]=(video,216)
        extensionIconMap["rm"]=(video,217)
        extensionIconMap["vob"]=(video,218)
        extensionIconMap["f4v"]=(video,219)
        
        //------------deflated-------------------------------
        extensionIconMap["zip"]=("icon_zip",501)
        extensionIconMap["gzip"]=("icon_zip",502)
        extensionIconMap["bzip2"]=("icon_zip",503)
        extensionIconMap["xzip"]=("icon_xzip",504)
        extensionIconMap["rar"]=("icon_rar",505)
        extensionIconMap["tar"]=("icon_tar",506)
        extensionIconMap["jar"]=("icon_jar",507)
        //				extensionIconMap["gz"]=("icon_tar",508)
        //				extensionIconMap["bz2"]=("icon_tar",509)
        //				extensionIconMap["xz"]=("icon_tar",510)
        
        
        //------------docs-------------------------------
        extensionIconMap["xml"]=("icon_xml",1)
        extensionIconMap["html"]=("icon_xml",2)
        extensionIconMap["xhtml"]=("icon_xml",3)
        extensionIconMap["txt"]=("icon_txt",4)
        extensionIconMap["doc"]=("icon_doc",5)
        extensionIconMap["docx"]=("icon_doc",6)
        extensionIconMap["xls"]=("icon_excel",7)
        extensionIconMap["xlsx"]=("icon_excel",8)
        extensionIconMap["pdf"]=("icon_pdf",9)
        extensionIconMap["pptx"]=("icon_pp",10)
        extensionIconMap["ppt"]=("icon_pp",11)
        extensionIconMap["plist"]=("icon_xml",12)

        
        
        //------------apk-------------------------------
        extensionIconMap["apk"] = ("icon_apk",400)
        extensionIconMap["ipa"] = ("icon_ipa",401)
        
        return extensionIconMap
        
    }
}
