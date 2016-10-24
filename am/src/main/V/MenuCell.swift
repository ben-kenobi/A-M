//
//  MenuCell.swift
//  anquanguanli
//
//  Created by apple on 16/3/22.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class MenuCell: UICollectionViewCell {
    
    lazy var icon:UIImageView=UIImageView()
    lazy var title:UILabel=UILabel()
    
    var mod:[String:String]?{
        didSet{
            if let mod=mod{
                icon.image=iimg(mod["icon"])
//                title.text=mod["title"]
            }
        }
    }
    
    func initUI(){
        let selbg=UIView()
        selbg.backgroundColor=iColor(0, 0, 0, 0.3)
        selectedBackgroundView=selbg
        selbg.layer.cornerRadius=7
        selbg.layer.masksToBounds=true
        
        //        selectionStyle = .None
        
        let v=UIView()
        contentView.addSubview(v)
        //        contentView.backgroundColor=UIColor.clearColor()
        backgroundColor=UIColor.clear
        v.addSubview(icon)
        v.addSubview(title)
        //        v.layer.cornerRadius=5
        //        v.layer.borderWidth=0.7
        //        v.layer.borderColor=UIColor.grayColor().CGColor
        v.layer.backgroundColor=UIColor.clear.cgColor
        v.snp.makeConstraints { (make) -> Void in
            make.top.left.right.bottom.equalTo(0)
            
        }
        
        
        icon.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(v).offset(-25)
            make.center.equalTo(icon.superview!)
            
        }
        title.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(title.superview!)
            make.bottom.equalTo(-7)
            
        }
        
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
