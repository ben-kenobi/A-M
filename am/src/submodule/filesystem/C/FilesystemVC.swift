//
//  FilesystemVC.swift
//  am
//
//  Created by apple on 16/5/17.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit


class FilesystemVC: PlatformVC {
    
    
    var selCB:((_ path:String)->Void)?
    
    var rightBtns:[UIView]=[UIView]()
    lazy var rightBBIs:[UIBarButtonItem]={
        return self.initBBIs()
    }()
    
    lazy var filesystemCV:FileSystemCV=FileSystemCV { [weak self](cv) in
        
        self?.up.isEnabled = (cv.curDir != "/") &&  FileUtil.isReadableDir(cv.outerDir)
        self?.star.setTitle((cv.curDir as NSString).lastPathComponent, for: UIControl.State.normal)
        self?.updateMulSelMode(self!.moreOperationBtns[4])
        self?.moreOperationBtns[5].isSelected = !self!.filesystemCV.rootOrHome
        if cv.mode == .selDir{
            self?.rightBBIs[0].isEnabled = iFm.isWritableFile(atPath:cv.curDir)
        }else if cv.mode == .selFile{
            self?.rightBBIs[0].isEnabled = !cv.multiSel && cv.selectedList.count > 0 && FileUtil.isReadableFile(cv.selectedList[0])
        }
    }
    
    
    lazy var up:UIButton = {
        let up = UIButton(frame: nil, img: iimg("back_pressed"), tar: self, action: #selector(self.onClicked(_:)), tag: 0)
        return up
    }()
    
    lazy var star:StarBtn={
        let star = StarBtn(frame: nil, img: iimg("discard"),  title: "ROOT", font: ibFont(15), titleColor: iColor(0xffee7600), titleHlColor: iColor(0xff0067ee),  tar: self, action: #selector(self.onClicked(_:)), tag: 0)
        star.setImage(iimg("favorite"), for: UIControl.State.selected)
        return star
        
    }()
    
    lazy var moreOperation:UIButton={
        let moreOperation = UIButton(frame: nil, img: iimg("more"), tar: self, action: #selector(self.onClicked(_:)), tag: 0)
        moreOperation.setImage(iimg("more")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: UIControl.State.selected)
        return moreOperation
    }()
    
    lazy var moreOperationBtns:[UIButton]={
        var moreOperationBtns = [UIButton]()
        let imgs = ["clipboard","mkdir","new_file","refresh","multiselector","homedir"]
        for str in imgs{
            let b = UIButton(frame: nil, img: iimg(str), bgcolor: UIColor.clear, corner: 0, bordercolor: iColor(0x33888888), borderW: 1, tar: self, action: #selector(self.onClicked(_:)), tag: 0)
            moreOperationBtns.append(b)
            b.imageEdgeInsets=UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
            b.imageView?.contentMode = .scaleAspectFit
        }
        moreOperationBtns[4].setImage(iimg("file_explorer"),for:UIControl.State.selected)
        moreOperationBtns[5].setImage(iimg("rootslash"),for:UIControl.State.selected)
        
        return moreOperationBtns
        
    }()
    lazy var moreOperationBar:UIView=self.initMoreOperationBar()
    
    
    lazy var dmcBtns:[UIButton]={
        var dmcBtns = [UIButton]()
        let imgs = ["delete","cut","copy"]
        for str in imgs{
            let b = UIButton(frame: nil, img: iimg(str), bgcolor: UIColor.clear, corner: 0, bordercolor: iColor(0x33888888), borderW: 1, tar: self, action: #selector(self.onClicked(_:)), tag: 0)
            dmcBtns.append(b)
            b.imageEdgeInsets=UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
            b.imageView?.contentMode = .scaleAspectFit
        }
        return dmcBtns
        
    }()
    lazy var dmcBar:UIView=self.initDmcBar()
    
    
    
    
    override func viewDidLoad() {
        platform=iConst.FILESYSTEM
        super.viewDidLoad()
        initUI()
        filesystemCV.rootOrHome=false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if rightBtns.count>0{
            return 
        }
        let views = navigationController?.navigationBar.subviews
        
        var idx = 0
        
        //before IOS 11
        for (_,v) in views!.enumerated(){
            if v.isKind(of: (NSClassFromString("UINavigationButton")!)){
                idx += 1
                if idx == 1{
                    continue
                }
                rightBtns.append(v as! UIButton)
            }
        }
        rightBtns.sort { (left, right) -> Bool in
            return left.x>right.x
        }
        
        
        //after IOS 11
        //*********begin*************
        func recblo(vs:[UIView]?)->(){
            for (_,v) in vs!.enumerated(){
                if v.isKind(of: (NSClassFromString("_UIButtonBarButton")!)){
                    idx += 1
                    if idx == 1{
                        continue
                    }
                    rightBtns.append(v)
                }else if(v.h==44){
                    print("+++\(v.frame)")
                    recblo(vs: v.subviews)
                }
            }
        }
        if rightBtns.count==0{
            recblo(vs: views)
        }
        rightBtns.sort { (left, right) -> Bool in
            return left.x>right.x
        }
        //**********end************
    }
    
    @objc func onItemClicked(_ sender:UIBarButtonItem){
        let tag = sender.tag
        
        if(tag==NavMenu.more.rawValue){
            showMoreDialog(sender)
        }else if tag == NavMenu.view.rawValue{
            showViewDialog(sender)
        }else if tag == NavMenu.sort.rawValue{
            showSortDialog(sender)
        }else if tag == NavMenu.search.rawValue{
            
        }else if tag == NavMenu.done.rawValue{
            selCB?(self.filesystemCV.getChoosedFile())
            (self.navigationController as! MainNavVC).back()
        }
        
    }
    @objc func onClicked(_ sender:UIButton){
        if sender == moreOperation{
            toggleMoreOperation(sender)
        }else if sender == moreOperationBtns[4]{
            self.filesystemCV.multiSel = !self.filesystemCV.multiSel
        }else if sender == up{
            self.filesystemCV.up()
        }else if sender == moreOperationBtns[5]{
            self.filesystemCV.rootOrHome = !self.filesystemCV.rootOrHome
        }else if sender == moreOperationBtns[3]{
            self.filesystemCV.refresh(false)
        }else if sender == moreOperationBtns[1]{
            mkDir()
        }else if sender == moreOperationBtns[2]{
            createFile()
        }else if sender == dmcBtns[0]{
            self.deleteSelectList()
        }
    
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
    }
    
    
}
