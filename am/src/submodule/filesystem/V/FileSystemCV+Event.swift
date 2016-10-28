//
//  FileSystemCV+Event.swift
//  am
//
//  Created by apple on 16/10/26.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

extension FileSystemCV{
    
    func up(){
        curDir=(curDir as NSString).deletingLastPathComponent
    }
    func refresh(_ noselMode:Bool){
        changeDir(curDir, resetSort: false, noseMode: noselMode)
        
    }
    
    func sort(_ type:Int){
        if comparator.setType(type) && fileList.count>0{
            fileList.sort { [weak self](le, ri) -> Bool in
                if let se = self{
                    return se.comparator.compare(se.curDir + "/" + le, se.curDir + "/" + ri) < 0
                }
                return true
            }
            reloadData()
        }
    }
    func screen(_ type:Int){
        if filter.setType(type){
            screenNsort(true)
        }
    }
    func screenNsort(_ noselMode:Bool){
        fileList.removeAll()
        for file in files{
            if filter.accept(curDir + "/" + file){
                fileList.append(file)
            }
        }
        fileList.sort { [weak self](le, ri) -> Bool in
            if let se = self{
                return se.comparator.compare(se.curDir + "/" + le, se.curDir + "/" + ri) < 0
            }
            return true
        }
        if noselMode{
            multiSel=false
        }
        reloadData()

    }
    func changeDir(_ file:String,resetSort:Bool,noseMode:Bool){
        if FileUtil.isReadableDir(file){
            _curDir=file
            if resetSort{
                filter.setType(0)
                comparator.setType(0)
            }
            updateData(noseMode)
            cdCB?(self)

        }
    }
    
    func updateData(_ noselMode:Bool){
        files = try! iFm.contentsOfDirectory(atPath: curDir)
        
        screenNsort(noselMode)
    }
    
    
    
    // mkdir
    func  mkDir(_ dirname:String)->String {
        if !iFm.isWritableFile(atPath: curDir){
            return "当前文件夹无写入权限"
        }
        let result = FileUtil.mkDir(curDir, dirname)
        if result == -1{
            return iConst.FILE_ALREADY_EXISTS
        }else if result == 1{
            refresh(false)
            return iConst.MKDIR_SUCCESS
        }else {
            return iConst.MKDIR_FAIL
        }
   
    }
    
    
    //createNewFile
    func  createNewFile(_ filename:String) ->String{
        if !iFm.isWritableFile(atPath: curDir){
            return "当前文件夹无写入权限"
        }
        let result = FileUtil.createNewFile(curDir, filename)
        if result == -1{
            return iConst.FILE_ALREADY_EXISTS
        }else if result == 1{
            refresh(false)
            return iConst.MKDIR_SUCCESS
        }else{
            return iConst.MKDIR_FAIL
        }
    }
}
