//
//  AutoDimListPop.swift
//  am
//
//  Created by apple on 16/11/3.
//  Copyright © 2016年 apple. All rights reserved.
//

import Foundation


class AutoDimListPop: BaseDialog {
    var headerH:CGFloat = 46{
        didSet{
            updateUI()
        }
    }
  
    var datas:[Any]?{
        didSet{
            updateUI()
        }
    }
   
    var title:String?
    var onItemSelCB:((_ item:Any,_ pos:Int)->Void)?
    var getCell:((_ tv:UITableView,_ item:Any,_ idx:Int)->UITableViewCell)?
    var selIdx:Int = -1{
        didSet{
            self.tv.reloadData()
        }
    }
    
    lazy var header:UIButton = {
        let header = ComUI.comBtnTitle("   "+self.title!)
        header.addTarget(self, action: #selector(self.onClick(_:)), for: UIControl.Event.touchUpInside)
        return header
    }()
    
    
    lazy var tv:AutoHeightTV = {
        let tv = AutoHeightTV(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: UITableView.Style.plain)
        tv.delegate=self
        tv.dataSource=self
        tv.estimatedRowHeight=60
        tv.separatorStyle = .singleLine
        tv.separatorInset = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 22)
        tv.showsVerticalScrollIndicator=false
        tv.bounces=false
        tv.rowHeight = UITableView.automaticDimension

        return tv    }()
    
    
    required init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(tv)
        tv.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
            make.height.width.equalTo(0)
        }
        self.backgroundColor=iColor(0x88000000)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension AutoDimListPop{
    
    @objc func onClick(_ sender:UIButton){
        if sender == self.header{
            self.dismiss();
        }
    }
    
    func updateUI(){
        tv.reloadData()
    }
    
    class func autoDimListPopWith(_ datas:[Any]?=nil,title:String?=nil,w:CGFloat?=nil,cb:((_ item:Any,_ pos:Int)->())?,getCell:((_ tv:UITableView,_ item:Any,_ idx:Int)->UITableViewCell)?)->Self{
        let pop = dialogWith()
        pop.title = title
        if let datas = datas{
            pop.datas=datas
        }
    
        if let w = w{
            pop.tv.wid = w
        }else{
            pop.tv.wid=300
        }
        pop.onItemSelCB = cb
        pop.getCell = getCell
        return pop
    }
    
}

extension AutoDimListPop:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return datas?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        return self.getCell!(tableView,datas![indexPath.row],indexPath.row)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        onItemSelCB?(datas![(indexPath as NSIndexPath).row],(indexPath as NSIndexPath).row)
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
    
    
}



