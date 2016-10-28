
//
//  ItemListVC.swift
//  am
//
//  Created by apple on 16/5/19.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class ItemListVC: FileChooserVC {
   
    fileprivate var mulSelMod:Bool = false
    var datas:[[String:Any]]?
    
    
    
    var rightBtns:[UIButton]=[UIButton]()
    lazy var rightBBIs:[UIBarButtonItem]={
        var rightBBIs = [UIBarButtonItem]()
        
        var item = ComUI.moreItem(self, sel: #selector(self.onItemClick(_:)))
       
        rightBBIs.append(item)
        
        item = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.trash, target: self, action: #selector(self.onItemClick(_:)))
        item.tag=NavMenu.trash.rawValue
        rightBBIs.append(item)
        
        item = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(self.onItemClick(_:)))
        item.tag=NavMenu.add.rawValue
        rightBBIs.append(item)
        
        item = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(self.onItemClick(_:)))
        item.tag = NavMenu.search.rawValue
        rightBBIs.append(item)
        
        return rightBBIs
    }()
    
    lazy var contentTV:UITableView={
        let contentTV = UITableView(frame: self.view.bounds, style: UITableViewStyle.plain)
        contentTV.delegate=self
        contentTV.dataSource=self
        contentTV.backgroundColor=UIColor(patternImage: iimg("common_bg")!)
        contentTV.separatorStyle = .none
        contentTV.rowHeight = UITableViewAutomaticDimension
        contentTV.estimatedRowHeight = 80
        contentTV.showsVerticalScrollIndicator=true
        contentTV.bounces=false
        return contentTV
        
    }()
    
    
    lazy var delBtn:UIButton={
        let delBtn = UIButton( img: iimg("delete"), bgcolor: iColor(0x55000000), corner: 10, bordercolor: iColor(0xff888888), borderW: 1, tar: self, action: #selector(self.multiDel), tag:0)
        return delBtn
    }()
}

extension ItemListVC{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(contentTV)
        contentTV.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        contentTV.contentInset=UIEdgeInsetsMake(5, 0, 15, 0)
        navigationItem.rightBarButtonItems=rightBBIs
        let views = navigationController?.navigationBar.subviews
        
        var idx = 0
        for (_,v) in views!.enumerated(){
            if v.isKind(of: (NSClassFromString("UINavigationButton")!)){
                idx += 1
                if idx == 1{
                    continue
                }
                rightBtns.append(v as! UIButton)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if mulSelMod {
            toggleSelMod()
        }
        self.updateData()
    }
    
    func onItemClick(_ sender:UIBarButtonItem){
        let tag = sender.tag
        
        if(tag==NavMenu.more.rawValue){
            var datas=[iStrings["exportEntries"]!,iStrings["importEntries"]!]
            if CommonUtils.isLogin(){
                datas += [iStrings["modifyAccessKey"]!]
            }
            datas.append(CommonService.isAccessKeyEnable(platform) ?
                iStrings["disableAccessKey"]! : iStrings["enableAccessKey"]!)
            
            _=ListPop.listPopWith(datas,cb:{
                (str,pos)->()  in
                if str == iStrings["exportEntries"]! {
                    self.selectDir()
                }else if str == iStrings["importEntries"]! {
                    self.selectFile()
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
        }else if tag == NavMenu.trash.rawValue{
            toggleSelMod()
        }else if tag == NavMenu.search.rawValue{
            showSearchDailog()
        }else if tag == NavMenu.add.rawValue{
            toDetailVC()
        }
    }
    
    func updateData(){
        
    }
    
    
    
    func toDetailVC(_ info:[String:Any]?=nil){
        let vc = ItemDetailVC(datas: StaticMod.ACC_MUTABLE_DATAS,info: info)
        
        navigationController?.show(vc, sender: nil)
    }
    func multiDel(){
        let count = contentTV.indexPathsForSelectedRows?.count ?? 0
        if count == 0 {
            iPop.toast("无被选中数据")
        }else{
            let av=CommonAlertView.viewWith("删除提醒", mes: "确定删除\(contentTV.indexPathsForSelectedRows?.count ?? 0)条数据？", btns: ["确定","取消"],cb: {
                (pos,dialog)->Bool in
                if pos == 0{
                    var set:Set = Set<String>()
                    var idxes:Set = Set<Int>()
                    for idxp in self.contentTV.indexPathsForSelectedRows!{
                        set.insert("\(self.datas![(idxp as NSIndexPath).row][iConst.ID]!)")
                        idxes.insert((idxp as NSIndexPath).row)
                    }
                    iPop.toast("删除\(AccountService.ins.delete(set))条数据")
                    self.datas!.removeAtIdxes(idxes: idxes)
                    self.contentTV.deleteRows(at: self.contentTV.indexPathsForSelectedRows!, with: UITableViewRowAnimation.fade)
                    self.toggleSelMod()

                }
                return true
            })
            _=av.show()
        }
        
    }
    class func showModifyAccessDialog(){
        let av=CommonEditDialog.viewWith("修改密码", phs:["输入新密码"], btns: ["确定","取消"],cb: {
            (pos,dialog)->Bool in
            if pos == 0{
                let dia = dialog as! CommonEditDialog
                let txts=dia.getTexts()
                if txts[0] == "" {
                    iPop.toast("新密码不能为空")
                    return false
                }else{
                   let b = CommonService.modifyAccessKey(CommonUtils.getAccessKey(), newAccessKey: txts[0])
                    if b{
                        iPop.toast("修改成功")
                        CommonUtils.setAccessKey(txts[0])
                        return true
                    }else{
                        iPop.toast("修改失败")
                        return false
                    }
                }
                
            }
            return true
        })
        _=av.show()
    }
    
    func showSearchDailog(){}
    
    func selectFile(){
        let vc = FilesystemVC()
        vc.filesystemCV.mode = .selFile
        navigationController?.show(vc, sender: nil)
        
    }
    func selectDir(){
        let vc = FilesystemVC()
        vc.filesystemCV.mode = .selDir
        navigationController?.show(vc, sender: nil)
    }

    
    func toggleSelMod(){
        mulSelMod = !mulSelMod
        contentTV.allowsMultipleSelection=mulSelMod
        
        let corner = 10,height=80
        if mulSelMod{
            view.addSubview(self.delBtn)
            delBtn.snp.makeConstraints { (make) in
                make.bottom.equalTo(corner)
                make.width.equalTo(view).multipliedBy(0.5)
                make.height.equalTo(height)
                make.centerX.equalTo(view)
            }
            delBtn.transform=CGAffineTransform(translationX: 0,y: CGFloat( height - corner))
            UIView.animate(withDuration: 0.3, animations: {
                self.delBtn.transform=CGAffineTransform.identity
            })
            contentTV.selectAll()
        }else{
            UIView.animate(withDuration: 0.3, animations: {
                self.delBtn.transform=CGAffineTransform(translationX: 0,y: CGFloat( height - corner))
                }, completion: { (b) in
                    if !self.mulSelMod{
                        self.delBtn.removeFromSuperview()
                    }
            })
        }
    }
}



extension ItemListVC:UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return datas?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        return  CommonListItemCell.cellWith(tableView, mod: datas![(indexPath as NSIndexPath).row], idx: indexPath)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !mulSelMod{
            tableView.deselectRow(at: indexPath, animated: true)
            toDetailVC(datas![(indexPath as NSIndexPath).row])
        }
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if AccountService.ins.delete("\(datas![(indexPath as NSIndexPath).row][iConst.ID]!)"){
            datas!.remove(at: (indexPath as NSIndexPath).row)
            
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        }
    }
    
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "DEL"
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !mulSelMod
    }
    
    
}
