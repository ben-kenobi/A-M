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
            if multiSel{
                multiSel=false
            }else{
                selectedList.removeAll()
            }
        }
        reloadData()
        cdCB?(self)
    }
    func changeDir(_ file:String,resetSort:Bool,noseMode:Bool){
        if FileUtil.isReadableDir(file){
            _curDir=file
            if resetSort{
                filter.setType(0)
                comparator.setType(0)
            }
            updateData(noseMode)
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
    
    
    //DeleteSelectedFiles
    func deleteSelectedListAsynchronously(){
        if selectedList.isEmpty || !iFm.isWritableFile(atPath: curDir){
            return
        }
        iPop.showProg("正在删除文件...")
       
        DispatchQueue.global().async {
            for file in self.selectedList{
                try? iFm.removeItem(atPath: file)
            }
            DispatchQueue.main.async {
                iPop.dismProg()
                iPop.toast("删除文件完成")
                self.refresh(true)
            }
        }
    }
    
    //DeleteFile
    func deleteFile(_ path:String,optDialog:BaseDialog?){
        var msg = ""
        if !iFm.isWritableFile(atPath:curDir){
            iPop.toast("当前位置文件无法删除");
            return
        }
        if FileUtil.isDir(path){
            msg = "确定删除文件( \((path as NSString).lastPathComponent) )及其下的所有文件？"
        }else{
            msg = "确定删除文件( \((path as NSString).lastPathComponent) )？"
        }
        
        let av=CommonAlertView.viewWith("警告", mes: msg, btns: ["确定","取消"], cb: { (idx, dialog) -> Bool in
            if idx == 0{
                self.deleteFileAsynchronously(path)
                optDialog?.dismiss()
            }
            return true
        }).show()
        av.backgroundColor=iColor(0x88000000)
        
    }

    func deleteFileAsynchronously(_ file:String){
        if  !iFm.isWritableFile(atPath: curDir){
            return
        }
        iPop.showProg("正在删除文件...")
        
        DispatchQueue.global().async {
            
            try? iFm.removeItem(atPath: file)
            
            DispatchQueue.main.async {
                iPop.dismProg()
                iPop.toast("删除文件完成")
                self.refresh(true)
            }
        }
    }
    
    
    
    //renameFile
    func renameFile(_ file:String,optDialog:BaseDialog?){
        if !iFm.isWritableFile(atPath: curDir){
            iPop.toast("当前位置文件无法重命名");
            return
        }
        if !iFm.isWritableFile(atPath: file){
            iPop.toast("无法修改该文件")
            return
        }
        let ed = CommonEditDialog.viewWith("输入新的文件名", phs: ["输入新文件名"], btns: ["确定","取消"]) { (idx, dialog) -> Bool in
            if idx == 0{
                let dia = dialog as! CommonEditDialog
                let newname = dia.getTexts()[0]
                if empty(newname){
                    iPop.toast("文件名不能为空")
                    return false
                }
               let result =  self.rename(file, toname: newname)
                if result == -1{
                    return false
                }
                optDialog?.dismiss()
            }
            return true
        }
        ed.defTexts=[(file as NSString).lastPathComponent]
        ed.backgroundColor=iColor(0x88000000)
        _=ed.show()
    
    }
    
    
    func rename(_ file:String,toname:String)->Int{
        let result = FileUtil.renameFile(file, toname: toname)
        if result==1 { refresh(false)}
        iPop.toast(result == 1 ? iConst.RENAME_SUCCESS
            : result == -1 ? iConst.RENAME_CONFLICT
            : result == -2 ? iConst.UNCHANGED
            : iConst.RENAME_FAIL)
        return result

    }
   
}
