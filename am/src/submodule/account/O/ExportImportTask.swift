//
//  ExportImportTask.swift
//  am
//
//  Created by apple on 16/11/1.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit


class ExportImportTask{
    
    
    static func execute(_ path:String,platform:String,afterExe:(()->Void)?=nil){
        iPop.showProg("请稍候。。。")
        DispatchQueue.global().async {
            var msg = ""
            if FileUtil.isWritableDir(path){
                msg = doExport(path, platform: platform)
            }else if FileUtil.isReadableFile(path){
                msg = doImport(path, platform: platform,afterExe:afterExe)
            }else{
                msg = "错误的文件"
            }
            DispatchQueue.main.async {
                iPop.dismProg()
                initMessageOnlyDialogNshow(msg)
                afterExe?()
            }

        }
    }
    
    static func doExport(_ dir:String,platform:String)->String{
        if !FileUtil.isWritableDir(dir){
            return "请指定有写入权限的文件夹位置进行导出"
        }
       
        let list  = CommonService.queryAllByPlatform(platform);
       
        if (list.count == 0){
            return "没有记录可以导出"
        }
        let data = try? JSONSerialization.data(withJSONObject: list, options: [])
        let dest = FileUtil.getNonexistBackupFile(dir, platform)
        var b = false
        if let data = data{
            b=(data as NSData).write(toFile: dest, atomically: true)
//            print(String(data: data, encoding: String.Encoding.utf8))
        }
        if b{
            return "导出完毕,文件保存在\n\(dest)"
        }else{
            return "导出失败!"
        }
    }
    static func doImport(_ file:String,platform:String,afterExe:(()->Void)?)->String{
        if !FileUtil.isReadableFile(file){
            return "请指定可读取的文件进行导入"
        }
        let data = NSData(contentsOfFile: file)!
//        print(String(data: data as Data, encoding: String.Encoding.utf8))

        let obj = try? JSONSerialization.jsonObject(with: data as Data, options: [])
        
        if let obj = obj ,let list = obj as? [[String:Any]]{
            let tup = CommonService.batchInsertByPlatform(platform, datas: list)
            return "导入完成,成功导入 \(tup.0) 条,失败 \(tup.1) 条";

        }else{
            return "文件格式不符合"
        }
   
    }
    
    
    static func initMessageOnlyDialogNshow(_ msg:String){
        _=CommonAlertView.viewWith("提示", mes: msg, btns: ["确定"]) { (pos, dialog) -> Bool in
            return true

        }.show()
    }
}
