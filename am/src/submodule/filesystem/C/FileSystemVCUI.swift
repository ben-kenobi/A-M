//
//  File.swift
//  am
//
//  Created by apple on 16/10/24.
//  Copyright © 2016年 apple. All rights reserved.
//

import Foundation
import UIKit

extension FilesystemVC{
    func initUI(){
        view.addSubview(filesystemCV)
        let bot = initBottomBar()
        filesystemCV.snp.makeConstraints { (make) in
            make.top.right.left.equalTo(0)
            make.bottom.equalTo(bot.snp.top)
        }
        filesystemCV.contentInset=UIEdgeInsetsMake(5, 0, 10, 0)
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
    
    func initBottomBar()->UIView{
        let bot = UIButton()
        bot.setBackgroundImage(iimg("background.9",pad:1), for: UIControlState.normal)
        bot.adjustsImageWhenHighlighted=false
        view.addSubview(bot)
        bot.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(52)
        }
        
        bot.addSubview(up)
        bot.addSubview(star)
        bot.addSubview(moreOperation)
        up.imageView?.contentMode = .scaleAspectFit
        moreOperation.imageView?.contentMode = .center
        
        up.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(0)
            make.width.equalTo(60)
            
        }
        moreOperation.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(up)
            make.right.equalTo(0)
            make.width.equalTo(60)
        }
        star.snp.makeConstraints { (make) in
            make.left.equalTo(up.snp.right)
            make.right.equalTo(moreOperation.snp.left)
            make.top.bottom.equalTo(up)
        }
        
        let line = UIView()
        line.backgroundColor=iColor(0xff33ff33)
        view.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.left.right.equalTo(0)
            make.bottom.equalTo(bot.snp.top)
        }
        
        return bot
        
    }
    
    func initBBIs()->[UIBarButtonItem]{
        var rightBBIs = [UIBarButtonItem]()
        
        var item = UIBarButtonItem(image: iimg("ic_menu_moreoverflow_normal_holo_light")?.alwayOrigin(), style: UIBarButtonItemStyle.plain, target: self, action:#selector(self.onItemClicked(_:)))
        item.tag=NavMenu.more.rawValue
        rightBBIs.append(item)
        
        item = UIBarButtonItem(image: iimg("ic_menu_view")?.alwayOrigin(), style: UIBarButtonItemStyle.plain, target: self, action:#selector(self.onItemClicked(_:)))
        item.tag=NavMenu.view.rawValue
        rightBBIs.append(item)
        
        item = UIBarButtonItem(image: iimg("ic_menu_sort_by_size")?.alwayOrigin(), style: UIBarButtonItemStyle.plain, target: self, action:#selector(self.onItemClicked(_:)))
        item.tag=NavMenu.sort.rawValue
        rightBBIs.append(item)
        
        item = UIBarButtonItem(image: iimg("ic_menu_search")?.alwayOrigin(), style: UIBarButtonItemStyle.plain, target: self, action:#selector(self.onItemClicked(_:)))
        item.tag = NavMenu.search.rawValue
        rightBBIs.append(item)
        
        return rightBBIs
    }
    func initMoreOperationBar()->UIView{
        let barh:CGFloat = 120
        let barw:CGFloat = 132
        let v = UIView(frame: nil, bg: iColor(0x33aaaaaa), corner: 0, bordercolor:iColor(0x88888888), borderW: 0)
        for btn in self.moreOperationBtns{
            v.addSubview(btn)
        }
        v.addCurve(tl: (true,12),bounds: CGRect(x:0,y:0,width:barw,height:barh))
        view.addSubview(v)
        v.layer.anchorPoint = CGPoint(x: 1, y: 1)
        v.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.right)
            make.centerY.equalTo(self.moreOperation.snp.top)
            make.height.equalTo(barh)
            make.width.equalTo(barw)
        }
        
        
        
        let base0 = self.moreOperationBtns[0]
        let base3 = self.moreOperationBtns[3]
        base0.snp.makeConstraints { (make) in
            make.top.left.equalTo(0)
        }
        self.moreOperationBtns[1].snp.makeConstraints { (make) in
            make.top.height.width.equalTo(base0)
            make.left.equalTo(base0.snp.right).offset(-1)
        }
        self.moreOperationBtns[2].snp.makeConstraints { (make) in
            make.top.height.width.equalTo(base0)
            make.left.equalTo(self.moreOperationBtns[1].snp.right).offset(-1)
            make.right.equalTo(0)
        }
        
        base3.snp.makeConstraints { (make) in
            make.left.height.equalTo(base0)
            make.bottom.equalTo(0)
            make.top.equalTo(base0.snp.bottom).offset(-1)
        }
        self.moreOperationBtns[4].snp.makeConstraints { (make) in
            make.height.width.top.equalTo(base3)
            make.left.equalTo(base3.snp.right).offset(-1)
        }
        self.moreOperationBtns[5].snp.makeConstraints { (make) in
            make.height.width.top.equalTo(base3)
            make.left.equalTo(self.moreOperationBtns[4].snp.right).offset(-1)
            make.right.equalTo(0)
        }
        
        v.transform=CGAffineTransform.init(scaleX: 0, y: 0)
        
        return v
    }
    
    
    func initDmcBar()->UIView{
        let dmcBar = UIView()
        dmcBar.backgroundColor=iColor(0x33aaaaaa)
        dmcBar.addCurve(tr: (true, 12), bounds: CGRect(x:0,y:0,width:150,height:55))
        view.addSubview(dmcBar)
        dmcBar.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.bottom.equalTo(self.up.snp.top)
            make.height.equalTo(55)
            make.width.equalTo(150)
        }
        for b in dmcBtns{
            dmcBar.addSubview(b)
        }
        dmcBtns[0].snp.makeConstraints { (make) in
            make.left.bottom.height.equalTo(dmcBar)
        }
        dmcBtns[1].snp.makeConstraints { (make) in
            make.bottom.height.width.equalTo(dmcBtns[0])
            make.left.equalTo(dmcBtns[0].snp.right).offset(-1)
        }
        dmcBtns[2].snp.makeConstraints { (make) in
            make.bottom.height.width.equalTo(dmcBtns[0])
            make.left.equalTo(dmcBtns[1].snp.right).offset(-1)
            make.right.equalTo(0)
        }
        
        return dmcBar
    }
}




class StarBtn:UIButton{
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.titleLabel?.textAlignment = .center
        self.imageView?.contentMode = .scaleAspectFit
        
        self.titleEdgeInsets = UIEdgeInsetsMake(2, -10, -2, 10)
        self.imageEdgeInsets = UIEdgeInsetsMake(16, -12, 16, 12)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
    //        let pad:CGFloat=12, h = contentRect.height-2*pad
    //        return CGRect(x:8,y:pad,width:h,height:h)
    //    }
    //    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
    //        let x = 8+contentRect.height-20
    //        return CGRect(x:x,y:0,width:contentRect.width-x,height:contentRect.height)
    //    }
}
