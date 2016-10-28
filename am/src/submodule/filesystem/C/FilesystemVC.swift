//
//  FilesystemVC.swift
//  am
//
//  Created by apple on 16/5/17.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit


class FilesystemVC: PlatformVC {
    
    
   
    
    var rightBtns:[UIButton]=[UIButton]()
    lazy var rightBBIs:[UIBarButtonItem]={
        return self.initBBIs()
    }()
    
    lazy var filesystemCV:FileSystemCV=FileSystemCV { [weak self](cv) in
        
        self?.up.isEnabled = (cv.curDir != "/") &&  FileUtil.isReadableDir(cv.outerDir)
        self?.star.setTitle((cv.curDir as NSString).lastPathComponent, for: UIControlState.normal)
    }
    
    
    lazy var up:UIButton = {
        let up = UIButton(frame: nil, img: iimg("back_pressed"), tar: self, action: #selector(self.onClicked(_:)), tag: 0)
        return up
    }()
    
    lazy var star:StarBtn={
        let star = StarBtn(frame: nil, img: iimg("discard"),  title: "ROOT", font: ibFont(15), titleColor: iColor(0xffee7600), titleHlColor: iColor(0xff0067ee),  tar: self, action: #selector(self.onClicked(_:)), tag: 0)
        star.setImage(iimg("favorite"), for: UIControlState.selected)
        return star
        
    }()
    
    lazy var moreOperation:UIButton={
        let moreOperation = UIButton(frame: nil, img: iimg("more"), tar: self, action: #selector(self.onClicked(_:)), tag: 0)
        moreOperation.setImage(iimg("more")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.selected)
        return moreOperation
    }()
    
    lazy var moreOperationBtns:[UIButton]={
        var moreOperationBtns = [UIButton]()
        let imgs = ["clipboard","mkdir","new_file","refresh","multiselector","homedir"]
        for str in imgs{
            let b = UIButton(frame: nil, img: iimg(str), bgcolor: UIColor.clear, corner: 0, bordercolor: iColor(0x33888888), borderW: 1, tar: self, action: #selector(self.onClicked(_:)), tag: 0)
            moreOperationBtns.append(b)
            b.imageEdgeInsets=UIEdgeInsetsMake(10, 8, 10, 8)
            b.imageView?.contentMode = .scaleAspectFit
        }
        moreOperationBtns[4].setImage(iimg("file_explorer"),for:UIControlState.selected)
        moreOperationBtns[5].setImage(iimg("rootslash"),for:UIControlState.selected)
        
        return moreOperationBtns
        
    }()
    lazy var moreOperationBar:UIView=self.initMoreOperationBar()
    
    
    lazy var dmcBtns:[UIButton]={
        var dmcBtns = [UIButton]()
        let imgs = ["delete","cut","copy"]
        for str in imgs{
            let b = UIButton(frame: nil, img: iimg(str), bgcolor: UIColor.clear, corner: 0, bordercolor: iColor(0x33888888), borderW: 1, tar: self, action: #selector(self.onClicked(_:)), tag: 0)
            dmcBtns.append(b)
            b.imageEdgeInsets=UIEdgeInsetsMake(12, 0, 12, 0)
            b.imageView?.contentMode = .scaleAspectFit
        }
        return dmcBtns
        
    }()
    lazy var dmcBar:UIView=self.initDmcBar()
    
    
    
    
    override func viewDidLoad() {
        platform=iConst.FILESYSTEM
        super.viewDidLoad()
        initUI()
        filesystemCV.rootOrHome=true
    }
    
    func onItemClicked(_ sender:UIBarButtonItem){
        let tag = sender.tag
        
        if(tag==NavMenu.more.rawValue){
            showMoreDialog(sender)
        }else if tag == NavMenu.view.rawValue{
            showViewDialog(sender)
        }else if tag == NavMenu.sort.rawValue{
            showSortDialog(sender)
        }else if tag == NavMenu.search.rawValue{
            
        }
        
    }
    func onClicked(_ sender:UIButton){
        if sender == moreOperation{
            toggleMoreOperation(sender)
        }else if sender == moreOperationBtns[4]{
            toggleMulSelMode(sender)
        }else if sender == up{
            self.filesystemCV.up()
        }else if sender == moreOperationBtns[5]{
            self.filesystemCV.rootOrHome = !self.filesystemCV.rootOrHome
            sender.isSelected = !self.filesystemCV.rootOrHome
        }else if sender == moreOperationBtns[3]{
            self.filesystemCV.refresh(false)
        }else if sender == moreOperationBtns[1]{
            mkDir()
        }else if sender == moreOperationBtns[2]{
            createFile()
        }
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
    }
    
    
}
