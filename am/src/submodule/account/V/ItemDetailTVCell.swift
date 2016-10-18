//
//  ItemDetailTVCell.swift
//  am
//
//  Created by apple on 16/5/19.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class ItemDetailTVCell: UITableViewCell {
    static let celliden = "celliden"
    
    var editable: UnsafeMutablePointer<Bool>?
    var mod:NSMutableDictionary?{
        didSet{
            updateUI()
        }
    }
    
    lazy var icon:UIButton={
        let icon = UIButton(frame: nil, img: iimg("ic_menu_search"), bgimg:iimg("lightblue_noselect.9.9"), hlbgimg: iimg("grey_noselect.9"), corner: 6, bordercolor: iConst.khakiBg, borderW: 1, tar: self, action: #selector(self.onClick(_:)), tag: 0)
        icon.contentMode = .scaleAspectFit
        return icon
        
    }()
    lazy var title:UILabel=UILabel(frame: nil, color: iColor(0xff666666), font: iFont(16), align: NSTextAlignment.left, line: 1, bgColor: iColor(0x00000000))
    lazy var tf:ClearableTF=ComUI.comTF1("")
    
    
    var distincColStrs:[String]{
        get{
            let distincColValues:[[AnyObject]] = AccountService.ins.queryDistinctColumn(self.mod!["key"] as! String)
            var ary = [String]()
            for ao in distincColValues{
                if !isBlank(ao[0] as! String){
                    ary.append(ao[0] as! String)
                }
            }
            return ary
        }
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        backgroundColor=UIColor.clear
        tf.onTxtChangeCB = {
            (tf) -> () in
            self.mod?.setValue(tf.text, forKey: "val")
        }
        initUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension ItemDetailTVCell{
    func onClick(_ sender:UIButton){
        if(sender == icon){
             ListPop.listPopWith(distincColStrs,title:mod!["title"] as? String, w:0.7,cb: { (str, pos) in
                self.tf.text=str
            }).show()
        }
        
    }
    func updateUI(){
        
        
        if let mod = mod{
            title.text=mod["title"] as? String
            tf.placeholder=mod["title"] as? String
            tf.text=mod["val"] as? String
        }else{
            title.text=""
            tf.placeholder=""
            tf.text=""
        }
        
        
        let b = editable?.pointee ?? false
        tf.isEnabled = b
        
        icon.snp_updateConstraints { (make) in
            make.width.equalTo(b ? 50 : 0)
            
        }
        
        
    }
    
    
    
    class func cellWith(_ tv:UITableView,mod:NSMutableDictionary,b:UnsafeMutablePointer<Bool>)->ItemDetailTVCell{
        var cell:ItemDetailTVCell? = tv.dequeueReusableCell(withIdentifier: celliden) as? ItemDetailTVCell
        if cell == nil{
            cell = ItemDetailTVCell(style: UITableViewCellStyle.value1, reuseIdentifier: celliden)
            cell!.editable=b
        }
        cell!.mod=mod
        return cell!
    }
    
    func initUI(){
        contentView.addSubview(icon)
        contentView.addSubview(title)
        contentView.addSubview(tf)
        
        title.snp_makeConstraints { (make) in
            make.left.top.equalTo(0)
            make.width.equalTo(70)
            make.bottom.equalTo(-8)
        }
        icon.snp_makeConstraints { (make) in
            make.top.equalTo(0)
            make.width.equalTo(0)
            make.bottom.equalTo(-8)
            make.right.equalTo(-30)
        }
        tf.snp_makeConstraints { (make) in
            make.left.equalTo(title.snp_right).offset(3)
            make.right.equalTo(icon.snp_left).offset(-3)
            make.top.equalTo(0)
            make.bottom.equalTo(-8)
        }
        
    }
}





