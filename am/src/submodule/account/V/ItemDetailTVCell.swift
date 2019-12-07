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
    let iconw:CGFloat=46
    let iconh:CGFloat=42
    
    var editable: UnsafeMutablePointer<Bool>?
    var mod:NSMutableDictionary?{
        didSet{
            updateUI()
        }
    }
    
    lazy var icon:UIButton={
        let icon = UIButton(frame: nil, img: iimg("ic_menu_search"), bgimg:iimg("lightblue_noselect.9.9"), hlbgimg: iimg("grey_noselect.9"),corner:0,  bordercolor: iConst.khakiBg, borderW: 1, tar: self, action: #selector(self.onClick(_:)), tag: 0)
         icon.addCurve(tl: (false,0), tr: (true,8), br: (true,8), bl: (false,0), bounds: CGRect(x:0,y:0,width:self.iconw,height:self.iconh))
        icon.contentMode = .scaleAspectFit
        return icon
        
    }()
  
    lazy var title:UILabel=UILabel(frame: nil, color: iColor(0xff666666), font: iFont(16), align: NSTextAlignment.left, line: 1, bgColor: iColor(0x00000000))
    lazy var tf:ClearableTF=ComUI.comTF1("")
    
    
    var distincColStrs:[String]{
        get{
            let distincColValues:[[Any]] = AccountService.ins.queryDistinctColumn(self.mod!["key"] as! String)
            var ary = [String]()
            for ao in distincColValues{
                if !isBlank(ao[0] as! String){
                    ary.append(ao[0] as! String)
                }
            }
            return ary
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
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
    @objc func onClick(_ sender:UIButton){
        if(sender == icon){
            let b = editable?.pointee ?? false
            if(b){
                 _=ListPop.listPopWith(distincColStrs,title:mod!["title"] as? String, w:0.7,cb: { (str, pos) in
                    self.tf.text=str
                }).show()
            }else{
                let pb = UIPasteboard.general
                pb.string=tf.text
                iPop.toast("copy")
            }
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
        
        icon.setImage((b ? iimg("ic_menu_search"):iimg("copy-icon")?.scale2w(26)), for: .normal)
        icon.setBackgroundImage(b ? iimg("lightblue_noselect.9.9") : nil, for: .normal)
        icon.layer.borderWidth = b ? 1 : 0

        icon.isHidden=b ? false : empty(mod!["val"] as? String) ? true : false
    }
    
    
    
    class func cellWith(_ tv:UITableView,mod:NSMutableDictionary,b:UnsafeMutablePointer<Bool>)->ItemDetailTVCell{
        var cell:ItemDetailTVCell? = tv.dequeueReusableCell(withIdentifier: celliden) as? ItemDetailTVCell
        if cell == nil{
            cell = ItemDetailTVCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: celliden)
            cell!.editable=b
        }
        cell!.mod=mod
        return cell!
    }
    
    func initUI(){
        contentView.addSubview(icon)
        contentView.addSubview(title)
        contentView.addSubview(tf)
        
        title.snp.makeConstraints { (make) in
            make.left.top.equalTo(0)
            make.width.equalTo(55)
            make.bottom.equalTo(-8)
        }
        icon.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.width.equalTo(iconw)
            make.bottom.equalTo(-8)
            make.right.equalTo(-0)
        }
        tf.snp.makeConstraints { (make) in
            make.left.equalTo(title.snp.right).offset(3)
            make.right.equalTo(icon.snp.left).offset(-0)
            make.top.equalTo(0)
            make.bottom.equalTo(-8)
        }
        
    }
}





