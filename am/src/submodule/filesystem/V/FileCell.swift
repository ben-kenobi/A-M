//
//  FileCell.swift
//  am
//
//  Created by apple on 16/10/25.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class FileCell: UICollectionViewCell {
    
    lazy var icon:UIImageView=UIImageView()
    lazy var name:UILabel=UILabel()
    lazy var indicator:UILabel=UILabel()
    
    var mod:[String:String]?{
        didSet{
            updateUI()
        }
    }
    func updateUI(){
        if let mod=mod{
            
        }

    }
    func initUI(){
        let selbg=UIView()
        selbg.backgroundColor=iColor(0xaaffee88)
        selectedBackgroundView=selbg
        selbg.layer.cornerRadius=3
        selbg.layer.masksToBounds=true
        
 
        backgroundColor=UIColor.clear
        contentView.addSubview(icon)
        contentView.addSubview(name)
        contentView.addSubview(indicator)
        name.lineBreakMode = NSLineBreakMode.byTruncatingMiddle
        self.name.numberOfLines=0
        name.font = iFont(12)
        name.textAlignment = .center
        name.textColor = iColor(0xff555555)
        
        indicator.cornerRadius=6
        
        indicator.snp.makeConstraints{(make)->Void in
            make.width.height.equalTo(12)
            make.centerX.equalTo(icon.snp.right)
            make.centerY.equalTo(icon.snp.bottom)
        }

        icon.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(45)
            make.centerX.equalTo(icon.superview!)
            make.top.equalTo(5)
            
        }
        name.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(-5)
            make.left.equalTo(3)
            make.right.equalTo(-2)
            make.top.equalTo(icon.snp.bottom)
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
