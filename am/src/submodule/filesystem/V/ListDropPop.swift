//
//  ListDropPop.swift
//  am
//
//  Created by apple on 16/10/28.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class ListDropPop: BaseDialog {
    
    let celliden = "listDropPopcelliden"
    var datas:[String]?{
        didSet{
            updateUI()
        }
    }
    var title:String?{
        didSet{
            (titleView.viewWithTag(11) as! UILabel).text=title
        }
    }
    var dropTitle:String?{
        didSet{
             (titleView.viewWithTag(12) as! UIButton).setTitle(dropTitle, for: UIControlState())
        }
    }
    var headerTitle:String?{
        didSet{
            (header.viewWithTag(10) as! UILabel).text=headerTitle
            updateUI()

        }
    }
    

    var selIdx:Int = -1
    
  
    var defH:CGFloat = 44{
        didSet{
            updateUI()
        }
    }
    
    
 
    
    var droplist:[String]?{
        didSet{
            if let droplist=droplist , droplist.count>0{
                if dropTitle == nil{
                    (titleView.viewWithTag(12) as! UIButton).setTitle(droplist[0], for: UIControlState())
                }
            }
        }
        
    }
    var onItemSelCB:((_ pos:Int,_ dialog:ListDropPop)->Void)?
    var onDropSelCB:((_ pos:Int,_ dialog:ListDropPop)->Void)?
    lazy var header:UIView = self.initHeaderView("",labtag:10)
    
    
    lazy var tv:AutoHeightTV = {
        let tv = AutoHeightTV(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: UITableViewStyle.plain)
        tv.delegate=self
        tv.dataSource=self
        tv.register(ListPopCell2.self, forCellReuseIdentifier: self.celliden)
        
        tv.separatorInset=UIEdgeInsetsMake(0, 22, 0, 22)
        tv.separatorStyle = .singleLine

        tv.showsVerticalScrollIndicator=true
        tv.bounces=false
        
        return tv    }()
    
    lazy var titleView:UIButton={
        let titleview=ComUI.comDropTitleView("", dropTitle: "", tar: self, sel: #selector(self.showDropDialog),labtag:11, droptag: 12)
        let lab = titleview.viewWithTag(11) as! UILabel
        let btn = titleview.viewWithTag(12) as! UIButton
        lab.font=ibFont(16)
        lab.lineBreakMode = .byTruncatingMiddle
        lab.numberOfLines=2
        titleview.addTarget(self, action: #selector(self.onClick(_:)), for: UIControlEvents.touchUpInside)
        
        return titleview
    }()
    
    required init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleView)
        titleView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(46)
            make.width.equalTo(self).multipliedBy(0.8)
        }
        contentView.addSubview(tv)
        tv.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(titleView.snp.bottom)
            make.height.width.equalTo(0)
        }
        
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initHeaderView(_ title:String,labtag:Int=0)->UIView{
        let view = UIView()
        view.backgroundColor=iConst.iGlobalBG
        let lab = UILabel(frame: nil, txt: "\(title)", color:iConst.iGlobalBlue, font: iFont(14), align: NSTextAlignment.left, line: 0, bgColor: UIColor.clear)
        view.addSubview(lab)
        lab.tag=labtag
        let divider = UIView()
        divider.backgroundColor=iColor(0xff33ff33)
        view.addSubview(divider)
        divider.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(0)
            make.height.equalTo(2)
        }
        lab.snp.makeConstraints { (make) in
            make.left.equalTo(4)
            make.right.equalTo(-2)
            make.top.equalTo(0)
            make.bottom.equalTo(divider.snp.top)
        }
        return view

    }
  
    
}





extension ListDropPop{
    func onClick(_ sender:UIButton){
        if sender == self.titleView{
            self.onItemSelCB?(-1,self)
        }
      
    }
    func updateUI(){
        tv.reloadData()
    }
    
  
    
    func showDropDialog(){
        let v = titleView.viewWithTag(12) as! UIButton
        let lp = ListPop.listPopWith(droplist,  w: v.w, cb: { (str, pos) in
            if self.dropTitle == nil{
                v.setTitle(str, for: UIControlState())
            }
            self.onDropSelCB?(pos,self)
        })
        lp.dropoffset=0
        lp.view.layer.cornerRadius=3
        _=lp.show(basev:self,anchor:v)
    }
    class func listDropPopWith(_ data:[String], droplist:[String],title:String,dropTitle:String?,cb:@escaping (_ pos:Int,_ dialog:ListDropPop)->(),gridsel:@escaping (_ pos:Int,_ dialog:ListDropPop)->())->ListDropPop{
        let pop = dialogWith() as ListDropPop
        pop.title = title
        pop.dropTitle=dropTitle
        pop.datas=data
        pop.droplist=droplist
        
        pop.onDropSelCB=cb
        
        pop.onItemSelCB = gridsel
        
        return pop
    }
}
extension ListDropPop:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return datas?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: self.celliden,for: indexPath) as! ListPopCell2
        //        cell.textLabel?.text=datas![indexPath.row]
        cell.lab.text=datas![(indexPath as NSIndexPath).row]
        cell.lab.textColor = (indexPath.row == selIdx) ? iColor(0xffee7766) : iColor(0xff333333)
        
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        onItemSelCB?((indexPath as NSIndexPath).row,self)
        dismiss()
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let _ = title{
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 66
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return defH
    }

}

    
    
    

class ListPopCell2:UITableViewCell{
    lazy var lab:UILabel = {
        let scl = UILabel()
        scl.textAlignment = .center
        self.contentView.addSubview(scl)
        scl.snp.makeConstraints( { (make) in
            make.left.right.top.bottom.equalTo(0)
        })
        return scl
        
    }()
    
    
}




