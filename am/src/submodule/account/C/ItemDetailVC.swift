//
//  ItemDetailVC.swift
//  am
//
//  Created by apple on 16/5/19.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class ItemDetailVC: BaseVC {
    var editable:Bool = true
    var info:[String:Any]?

    var datas:[NSMutableDictionary]?
    
    lazy var contentTV:UITableView={
        let contentTV = UITableView(frame: self.view.bounds, style: UITableViewStyle.plain)
        contentTV.delegate=self
        contentTV.dataSource=self
        
//        let iv = UIImageView()
//        iv.image=iimg("background.9")
//        contentTV.backgroundView = iv
        contentTV.separatorStyle = .none
        contentTV.rowHeight = 50
//        contentTV.contentInset=UIEdgeInsetsMake(15, 15, 15, -15)
        contentTV.showsVerticalScrollIndicator=true
        contentTV.bounces=false
        return contentTV
        
    }()
    
    lazy var commit:UIButton = ComUI.comBtn1(self, sel: #selector(self.onClick(_:)), title: (self.info==nil ? "保存信息" : "更新信息"))
    
    
    convenience init(datas:[NSMutableDictionary],info:[String:Any]?){
        self.init()
        self.datas=datas
        self.info=info
        if let inf = self.info {
            editable = false
            for dict in self.datas!{
                dict.setValue(inf[dict.value(forKey: "key") as! String], forKey: "val")
            }
        }
        
    }
    
    
    

}

extension ItemDetailVC{
    override func viewDidLoad() {
        super.viewDidLoad()
        let item = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.edit, target: self, action:#selector(self.onItemClick(_:)))
        item.tag=NavMenu.edit.rawValue
        navigationItem.rightBarButtonItem=item
        view.addSubview(commit)
        let container = UIButton()
        container.isUserInteractionEnabled=true
        container.setBackgroundImage(iimg("background.9")?.stretch(), for: .normal)
        
        view.addSubview(container)
        container.addSubview(contentTV)
        commit.snp.makeConstraints { (make) in
            make.bottom.equalTo(-12)
            make.centerX.equalTo(commit.superview!)
            make.height.equalTo(38)
            make.width.equalTo(self.view.snp.width).multipliedBy(0.7)
        }
        container.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
            make.bottom.equalTo(commit.snp.top).offset(-5)
        }
        contentTV.snp.makeConstraints { (make) in
            make.top.left.equalTo(15)
            make.bottom.right.equalTo(-15)
        }
        
        updateUI()
    }
    
    func onItemClick(_ sender:UIBarButtonItem){
        if(sender.tag==NavMenu.edit.rawValue){
            toggleEditable()
        }
    }
    
    
    func onClick(_ sender:UIButton){
        if(sender == commit){
            if isBlank(datas![0]["val"] as? String){
                iPop.toast("\(datas![0]["title"]!) 不能为空!")
                focusAtRow(0)
                return
            }
            
            var dict = [String:String]()
            for md in datas!{
                dict[md["key"] as! String]=md["val"] as? String

            }
            if let info = info{
                dict[iConst.ID]="\(info[iConst.ID]!)"
            }
            if AccountService.ins.addOrUpdate(dict) {
                toggleEditable()
                iPop.toast(" 成功! ")
            }else{
                 iPop.toast(" 失败! ")
            }
                
        }
    }
    
    
    
    func toggleEditable(){
        editable = !editable
        updateUI()
    }
    
    
    
    func updateUI(){
        contentTV.reloadData()
        commit.snp.updateConstraints { (make) in
            make.height.equalTo(self.editable ? 38 : 0)
        }
    }
    
}

extension ItemDetailVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return datas?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        return ItemDetailTVCell.cellWith(tableView, mod: datas![(indexPath as NSIndexPath).row], b: &editable)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func focusAtRow(_ row:Int){
        (contentTV.cellForRow(at: IndexPath.init(row: row, section: 0)) as! ItemDetailTVCell).tf.becomeFirstResponder()
    }
    
    
}
