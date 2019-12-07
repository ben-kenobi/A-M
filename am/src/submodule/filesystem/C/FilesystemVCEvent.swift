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
        }).show(self,anchor:rightBtns[2])
        pop.selIdx = self.filesystemCV.comparator.type

    }
    func showMoreDialog(_ sender:UIBarButtonItem){
        var datas=[iStrings["mark"]!,iStrings["settings"]!,iStrings["usage"]!]
        if CommonUtils.isLogin(){
            datas += [iStrings["modifyAccessKey"]!]
            datas.append(TouchIDMan.isBioAuthEnable(platform) ?
                iStrings["disableBioAuth"]! : iStrings["enableBioAuth"]!)
        }
        datas.append(CommonService.isAccessKeyEnable(platform) ?
            iStrings["disableAccessKey"]! : iStrings["enableAccessKey"]!)
        
        _=ListPop.listPopWith(datas,cb:{
            (str,pos)->()  in
            if str == iStrings["mark"]! {
                
            }else if str == iStrings["settings"]! {
                
            }else if str == iStrings["usage"]! {
                self.initNshowUsagePanel()
            }else if str == iStrings["disableBioAuth"]! || str == iStrings["enableBioAuth"]! {
                let tup = TouchIDMan.toggleBioAuthAceess(self.platform)
                if tup.0{
                    iPop.toast("操作成功")
                }else{
                    iPop.toast("操作失败\n\(tup.1)")
                }
            } else if str == iStrings["enableAccessKey"]! || str ==  iStrings["disableAccessKey"]!{
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
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                self.moreOperationBar.transform=tran
            }) { (suc) in
                sender.isSelected=false
                sender.isEnabled=true
            }
        }else{
            sender.isSelected=true
            _=moreOperationBar.transform
            let tran =  CGAffineTransform.identity
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                self.moreOperationBar.transform=tran
            }) { (suc) in
                sender.isEnabled=true
            }

          }
    }
    
    func updateMulSelMode(_ sender:UIButton){
        let mulsel = !self.filesystemCV.multiSel
        dmcBar.isHidden = mulsel
        sender.isSelected = !mulsel
    }
    
    
    
    
    func initNshowUsagePanel(){
        
        let pop = AutoDimListPop.autoDimListPopWith(["",""], title: "    使用情况", w: 320, cb: nil) { (tv, item, pos) -> UITableViewCell in
            if pos==0{
                return self.getUsageCell()
            }else{
                return self.getUUIDCell()
            }
        }
        _=pop.show(self)
    }
    func getUsageCell()->UITableViewCell{
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: nil)
        cell.selectionStyle = .none

        let pv = UIProgressView(frame: nil, bg: iColor(0xffbbbbbb), corner: 4, bordercolor: iConst.khakiBg, borderW: 1)
        let title = UILabel(frame: nil, txt: "存储:", color: iColor(0xff555555), font: iFont(17), align: NSTextAlignment.left, line: 1)
        cell.contentView.addSubview(pv)
        cell.contentView.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(pv)
            make.left.equalTo(12)
            make.width.equalTo(50)
        }
        pv.snp.makeConstraints { (make) in
            make.top.equalTo(18)
            make.bottom.equalTo(-18)
            make.left.equalTo(title.snp.right)
            make.right.equalTo(-16)
            make.height.equalTo(38)
        }
        let tup = FileUtil.sysUsageDescription()
        pv.progress = tup.1
        pv.progressViewStyle = .bar
        pv.progressTintColor = iColor(0xffff8844)
        
        let lab = UILabel(frame: nil, txt: tup.0, color: iColor(0xff5522ee), font: iFont(15), align: NSTextAlignment.center, line: 0)
        pv.addSubview(lab)
        lab.snp.makeConstraints { (make) in
            make.left.equalTo(6)
            make.right.equalTo(-4)
            make.top.bottom.equalTo(0)
        }
        
        return cell
    }
    func getUUIDCell()->UITableViewCell{
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: nil)
        cell.selectionStyle = .none

        let tf = UILabel(frame: nil, txt: "", color: iConst.iGlobalBlue, font: iFont(14), align: NSTextAlignment.center, line: 0, bgColor: iConst.iGlobalBG)
        let lab = UILabel(frame: nil, txt: "本机UUID:", color: iColor(0xff555555), font: iFont(17), align: NSTextAlignment.center, line: 1)
        
        let btn = CBBtn(frame: nil,title: "复制", font: iFont(17), titleColor: iColor(0xff5577ff), titleHlColor: iColor(0xffffffff), bgimg: iimg("lightblue_noselect.9",pad:0.5), hlbgimg: iimg("button_select.9",pad:0.5), action:nil, tag: 0)
        btn.cb={
            (sender) in
            FileUtil.copy2ClipBoard(UUID!)
            iPop.toast("复制成功")
        }
        
        
        cell.contentView.addSubview(tf)
        cell.contentView.addSubview(lab)
        cell.contentView.addSubview(btn)
        lab.snp.makeConstraints { (make) in
            make.top.left.equalTo(0)
            make.height.equalTo(44)
            make.width.equalTo(100)
        }
        
        btn.snp.makeConstraints { (make) in
            make.centerY.equalTo(lab)
            make.right.equalTo(-22)
            make.width.equalTo(58)
            make.height.equalTo(32)
        }
        
        tf.snp.makeConstraints { (make) in
            make.top.equalTo(lab.snp.bottom)
            make.bottom.equalTo(-8)
            make.left.equalTo(5)
            make.right.equalTo(-5)
            make.height.equalTo(38)
        }
        
        tf.text=UUID

        return cell
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
    
    
    //deleteFile
    func deleteSelectList(){
        if filesystemCV.selectedList.isEmpty{
            iPop.toast("无选中文件")
        }else if !iFm.isWritableFile(atPath:filesystemCV.curDir){
            iPop.toast("当前位置文件无法删除");
        } else {
            _=CommonAlertView.viewWith("警告", mes: "确认删除 \(filesystemCV.selectedList.count) 个条目？ 将无法恢复", btns: ["确定","取消"], cb: { (idx, dialog) -> Bool in
                if idx == 0{
                    self.filesystemCV.deleteSelectedListAsynchronously()
                }
                return true
            }).show()
            
        }
    }
}
    
   
