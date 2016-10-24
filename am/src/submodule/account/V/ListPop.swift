//
//  ListPop.swift
//  am
//
//  Created by apple on 16/5/18.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class ListPop: BaseDialog {
    var headerH:CGFloat = 46{
        didSet{
            updateUI()
        }
    }
    var defH:CGFloat = 44{
        didSet{
            updateUI()
        }
    }
    
    let celliden = "listPopcelliden"
    var datas:[String]?{
        didSet{
            updateUI()
        }
    }
    
    var key:String?{
        didSet{
            datas=iStrary[key ?? ""]
        }
    }
    var title:String?
    var onItemSelCB:((_ str:String,_ pos:Int)->Void)?
    
    
    
    lazy var header:UIView = {
        let header = ComUI.comTitleView("   "+self.title!)
        return header
    }()
    
    
    lazy var tv:AutoHeightTV = {
        let tv = AutoHeightTV(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: UITableViewStyle.plain)
        tv.delegate=self
        tv.dataSource=self
        tv.register(ListPopCell.self, forCellReuseIdentifier: self.celliden)
        
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator=true
        tv.bounces=false
        
        return tv    }()
    
    
    required init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(tv)
        tv.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
            make.height.width.equalTo(0)
        }
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension ListPop{
    
    func updateUI(){
        tv.reloadData()
    }
    
    class func listPopWith(_ datas:[String]?=nil,title:String?=nil,key:String?=nil,w:CGFloat?=nil,cb:@escaping (_ str:String,_ pos:Int)->())->Self{
        let pop = dialogWith()
        pop.title = title
        if let datas = datas{
            pop.datas=datas
        }
        if let key = key {
            pop.key = key
        }
        if let w = w{
            pop.tv.wid = w
        }else{
            pop.tv.wid=170
        }
        pop.onItemSelCB = cb
        return pop
    }
    
}

extension ListPop:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return datas?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: self.celliden,for: indexPath) as! ListPopCell
//        cell.textLabel?.text=datas![indexPath.row]
        cell.scrolLab.text=datas![(indexPath as NSIndexPath).row]
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        onItemSelCB?(datas![(indexPath as NSIndexPath).row],(indexPath as NSIndexPath).row)
        dismiss()
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let _ = title{
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let _ = title{
            return headerH
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return defH
    }
    
}

class ListPopCell:UITableViewCell{
    lazy var scrolLab:ScrolLab = {
        let scl = ScrolLab()
        self.contentView.addSubview(scl)
        scl.snp.makeConstraints( { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.bottom.equalTo(0)
        })
        return scl
    
    }()
    
    
}
