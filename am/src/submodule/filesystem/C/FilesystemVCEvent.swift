//
//  FilesystemVCEvent.swift
//  am
//
//  Created by apple on 16/10/24.
//  Copyright © 2016年 apple. All rights reserved.
//

import Foundation
import UIKit

extension FilesystemVC{
    
    
    func showViewDialog(_ sender:UIBarButtonItem){
        let datas=[iStrings["allfile"]!,iStrings["onlyfile"]!,iStrings["onlydirectory"]!,iStrings["onlyinvalid"]!,iStrings["onlywriteablefile"]!,iStrings["onlyreadablefile"]!]
        
        let pop = ListPop.listPopWith(datas,cb:{
            [weak self] (str,pos)->()  in
            self?.filesystemCV.screen(pos)
        }).show(self,anchor:rightBtns[1])
        pop.selIdx = self.filesystemCV.filter.type

    }
    func showSortDialog(_ sender:UIBarButtonItem){
        let datas=[iStrings["byNameAsc"]!,iStrings["byNameDesc"]!,iStrings["bySizeAsc"]!,iStrings["bySizeDesc"]!,iStrings["byTimeAsc"]!,iStrings["byTimeDesc"]!]
        
        let pop = ListPop.listPopWith(datas,cb:{
            [weak self](str,pos)->()  in
            self?.filesystemCV.sort(pos)
        }).show(self,anchor:rightBtns[1])
        pop.selIdx = self.filesystemCV.comparator.type

    }
    func showMoreDialog(_ sender:UIBarButtonItem){
        var datas=[iStrings["mark"]!,iStrings["settings"]!,iStrings["usage"]!]
        if CommonUtils.isLogin(){
            datas += [iStrings["modifyAccessKey"]!]
        }
        datas.append(CommonService.isAccessKeyEnable(platform) ?
            iStrings["disableAccessKey"]! : iStrings["enableAccessKey"]!)
        
        _=ListPop.listPopWith(datas,cb:{
            (str,pos)->()  in
            if str == iStrings["mark"]! {
                
            }else if str == iStrings["settings"]! {
                
            }else if str == iStrings["usage"]! {
                
            }else if str == iStrings["enableAccessKey"]! || str ==  iStrings["disableAccessKey"]!{
                if CommonService.toggleAccessibility(self.platform){
                    iPop.toast("操作成功")
                }else{
                    iPop.toast("操作失败")
                }
            }else if str == iStrings["modifyAccessKey"]! {
                ItemListVC.showModifyAccessDialog()
            }
        }).show(self,anchor:rightBtns[0])
    }
    func toggleMoreOperation(_ sender:UIButton){
        
        
        if sender.isSelected {
            sender.isEnabled=false
            let tran = CGAffineTransform.init(scaleX: 0.0001, y: 0.0001)
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.moreOperationBar.transform=tran
            }) { (suc) in
                sender.isSelected=false
                sender.isEnabled=true

            }
        }else{
            sender.isSelected=true
            _=moreOperationBar.transform
            let tran =  CGAffineTransform.identity
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.moreOperationBar.transform=tran
            }) { (suc) in
                sender.isEnabled=true
            }

          }
    }
    
    func toggleMulSelMode(_ sender:UIButton){
        let mulsel = !self.filesystemCV.multiSel
        self.filesystemCV.multiSel = mulsel
        dmcBar.isHidden = !mulsel
        sender.isSelected=mulsel
    }
    
    
    
    
    //mkdir
    func mkDir(){
        
        let av=CommonEditDialog.viewWith("新建文件夹", phs:["输入要创建的文件夹名称"], btns: ["确定","取消"],cb: {
            [weak self](pos,dialog)->Bool in
            if pos == 0{
                let dia = dialog as! CommonEditDialog
                let txts=dia.getTexts()
                if txts[0] == "" {
                    iPop.toast("不能为空")
                    return false
                }else{
                    if let se = self{
                        let msg = se.filesystemCV.mkDir(txts[0])
                        iPop.toast(msg)
                        return  msg != iConst.FILE_ALREADY_EXISTS
                    }
                }
                
            }
            return true
            })
        av.defTexts=["新建文件夹"]
        _=av.show(self)
    }
    
    //createFile
    func createFile(){
        
        let av=CommonEditDialog.viewWith("创建文件", phs:["输入要创建的文件名称"], btns: ["确定","取消"],cb: {
            [weak self](pos,dialog)->Bool in
            if pos == 0{
                let dia = dialog as! CommonEditDialog
                let txts=dia.getTexts()
                if txts[0] == "" {
                    iPop.toast("不能为空")
                    return false
                }else{
                    if let se = self{
                        let msg = se.filesystemCV.createNewFile(txts[0])
                        iPop.toast(msg)
                        return  msg != iConst.FILE_ALREADY_EXISTS
                    }
                }
                
            }
            return true
            })
        av.defTexts=["untitled"]
        _=av.show(self)
        
    }
}
    
   
