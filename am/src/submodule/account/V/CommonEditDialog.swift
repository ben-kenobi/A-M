//
//  CommonEditDialog.swift
//  am
//
//  Created by apple on 16/5/28.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class CommonEditDialog: CommonDialog {
    var phs:[String]?{
        didSet{
            let top = (phs?.count ?? 0) > 1 ? 10:30
            lv.snp.updateConstraints { (make) in
                make.top.equalTo(top)
                make.bottom.equalTo(-top)
            }
            lv.reloadData()
        }
    }
    
    lazy var lv:AutoHeightTV={
        let tv = AutoHeightTV(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: UITableViewStyle.plain)
        tv.autoWid=false
        tv.delegate=self
        tv.dataSource=self
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator=true
        tv.bounces=false
        tv.backgroundColor=UIColor.clear
        tv.rowHeight = 50
        self.midContent.addSubview(tv)
        tv.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.bottom.width.height.equalTo(0)
        }
        return tv
    
    
    }()
    
    
    static func viewWith(_ title:String,phs:[String],btns:[String],cb:((_ pos:Int,_ dialog:CommonDialog)->Bool)?)->Self{
        let av = self.dialogWith()
        av.titleLab.text=title
        av.btns=btns
        av.cb=cb
        av.phs=phs
        return av
    }

    
    func getTexts()->[String]{
        var ary = [String]()
        for cell in lv.visibleCells{
            ary.append((cell as! ItemEditCell).tf.text ?? "")
        }
        return ary
    }

}

extension CommonEditDialog:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return phs?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        return ItemEditCell.cellWith(tableView, ph: phs![(indexPath as NSIndexPath).row])
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
        
    }
 
}



extension CommonEditDialog{
    class ItemEditCell: UITableViewCell {
        
        var ph:String?{
            didSet{
                tf.placeholder=ph
            }
        }
        
        
        lazy var tf:ClearableTF=ComUI.comTF1("")
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.selectionStyle = .none
            backgroundColor=UIColor.clear
            initUI()
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        class func cellWith(_ tv:UITableView,ph:String)->ItemEditCell{
            var cell:ItemEditCell? = tv.dequeueReusableCell(withIdentifier: celliden) as? ItemEditCell
            if cell == nil{
                cell = ItemEditCell(style: UITableViewCellStyle.value1, reuseIdentifier: celliden)
                
            }
            cell!.ph=ph
            return cell!
        }
        
        func initUI(){
            contentView.addSubview(tf)
            tf.snp.makeConstraints { (make) in
                make.left.equalTo(3)
                make.right.equalTo(-3)
                make.top.equalTo(5)
                make.bottom.equalTo(-5)
            }
            
        }
    }


    

}





