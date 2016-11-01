//
//  FileSystemCV.swift
//  am
//
//  Created by apple on 16/10/24.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

enum FileSystemMode {
    case normal
    case selFile
    case selDir
}


class FileSystemCV: UICollectionView {
    let celliden = "cvcelliden"
    var mode:FileSystemMode = .normal

    
    var longPressed:Bool=false
    var _multiSel:Bool = false
    var multiSel:Bool{
        get{
            return _multiSel
        }
        set{
            if _multiSel != newValue{
                _multiSel=newValue
                selectedList.removeAll()
                reloadData()
                self.cdCB?(self)
            }
        }
    }
    var rootOrHome:Bool=true{
        didSet{
            if rootOrHome{
                curDir="/"
            }else{
                curDir=NSHomeDirectory()
            }
        }
    }
    var cdCB:((_ cv:FileSystemCV)->Void)?
    
   var comparator:IFileComparator=IFileComparator()
    
   var filter:IFileFilter=IFileFilter()

    
    
    var fileList:[String]=[], copyList:[String]=[], moveList:[String]=[], selectedList:[String]=[],files:[String] = []
    
    var _curDir:String = "/"
    var curDir:String{
        get{
            return _curDir
        }
        set{
            if _curDir == newValue{
                changeDir(newValue, resetSort: false, noseMode: false)
            }else{
                changeDir(newValue, resetSort: true, noseMode: true)
            }
        }
    }
    var outerDir:String{
        get{
            return (curDir as NSString).deletingLastPathComponent
        }
    }
    
    
    
    init(cb:@escaping ((_ cv:FileSystemCV)->Void)){
        let fl = UICollectionViewFlowLayout()
        fl.minimumInteritemSpacing=2
        fl.minimumLineSpacing=4
        fl.sectionInset=UIEdgeInsetsMake(2, 2, 2, 2)
        let col:CGFloat = 5
        let wid = min(iScrW,iScrH)
        let w = (wid - 2*(col+1))/col
        fl.itemSize = CGSize(width:w,height:w*1.4)
        
        super.init(frame: CGRect(x:0,y:0,width:0,height:0), collectionViewLayout: fl)
        delegate=self
        dataSource=self
        register(FileCell.self, forCellWithReuseIdentifier:self.celliden)
        backgroundColor=UIColor.white
        showsVerticalScrollIndicator=true
        bounces=false
        
        self.cdCB=cb
       let lp = UILongPressGestureRecognizer(target: self, action: #selector(self.lp(_:)))
        lp.minimumPressDuration=0.6
        self.addGestureRecognizer(lp)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func lp(_ sender:UILongPressGestureRecognizer){
        longPressed=true
        if sender.state == .cancelled{
            let po = sender.location(in: sender.view)
            let idx=self.indexPathForItem(at: po)
            if let idx = idx {
                initNshowOptionDialog(idx)
            }
        }
        
        sender.isEnabled=false
        sender.isEnabled=true

    }
    
    
    func initNshowOptionDialog(_ ip:IndexPath){
        let name = fileList[ip.row]
        let path = FileUtil.fullPath(name, curDir)

        var data =  [ "delete",
                        "rename", "copy", "move", "detail" ,"selectAll","multiselectorMode" ]
        data[6] = self.multiSel ? "退出多选模式" : "进入多选模式"
        let listDropPop = ListDropPop.listDropPopWith(data,droplist: iStrary["openaslist1"]!, title:name ,dropTitle:"打开方式", dropcb: { (pos, dialog) in
            
            },itemsel: nil)
        listDropPop.onItemSelCB = { (pos, dialog) in
            if pos == -1{
                dialog.dismiss()
            }else if pos==0{
                self.deleteFile(path,optDialog:listDropPop)
            }else if pos == 1{
                self.renameFile(path,optDialog:listDropPop)
            }else if pos == 5{
                self.selectAll()
                dialog.dismiss()
            }else if pos == 6{
                self.multiSel = !self.multiSel
                if self.multiSel{
                    _ = self.selectFile(path)
                }
                dialog.dismiss()
            }
        }
        listDropPop.onDismissCB = {
            (dialog) in
            if let idxes = self.indexPathsForSelectedItems ,idxes.count>0{
                self.deselectItem(at: idxes[0], animated: true)
            }
            self.longPressed=false
            
        }
        FileUtil.fileDetailDescription(path) { (str) in
            listDropPop.headerTitle=str
        }
        _=listDropPop.show()
    }
    
}










