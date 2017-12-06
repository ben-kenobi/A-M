//
//  BaseDialog.swift
//  am
//
//  Created by apple on 16/5/18.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class BaseDialog: UIView {
    lazy var view:UIView={
        let view = UIView()
        
        view.layer.backgroundColor=UIColor.white.cgColor
        view.layer.cornerRadius=6
        view.layer.borderColor=iColor(190,190,190).cgColor
        view.layer.borderWidth=1
        view.layer.shadowOpacity=1
        view.layer.shadowOffset=CGSize(width: 2, height: 2)
        view.layer.shadowRadius=6
        view.layer.shadowColor=iColor(0xff666666).cgColor
        view.layer.masksToBounds=false
        
        
        return view
    }()
    var dropoffset:CGFloat=5
    lazy var contentView:UIView={
        let contentView = UIView()
        contentView.layer.masksToBounds=true
        contentView.layer.backgroundColor=iConst.khakiBg.cgColor
        contentView.layer.cornerRadius=8
        return contentView
    }()
    
    var anchor:UIButton?
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor=UIColor.clear
        addSubview(view)
        view.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.top.left.width.height.equalTo(view)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !view.frame.contains((touches.first?.location(in: self))!){
            dismiss()
        }
    }
    
    var onDismissCB:((_ dialog:BaseDialog)->Void)?
    
    func dismiss(){
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: UIViewAnimationOptions(), animations: {
            self.alpha=0.02
            //            self.transform=CGAffineTransformMakeScale(0.1,0.1)
        }) { (b) in
            self.onDismissCB?(self)
            self.removeFromSuperview()
            self.anchor?.isSelected=false
        }
    }
    
    func showCenter(){
        view.snp.makeConstraints { (make) in
            make.center.equalTo(view.superview!)
        }
        alpha=0
        view.transform=CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: UIViewAnimationOptions(), animations: {
            self.alpha=1
            self.view.transform=CGAffineTransform.identity
        }) { (b) in
            
        }
    }
    func drowDown(_ anchor:UIView){
        //        let rect = anchor.convertRect(anchor.bounds, toView:self)
        view.layer.anchorPoint=CGPoint(x: 0.5, y: 0)
        
        view.snp.makeConstraints { (make) in
            make.centerY.equalTo(anchor.snp.bottom).offset(dropoffset)
            make.right.equalTo(anchor.snp.right)
        }
        
        alpha=0
        view.transform=CGAffineTransform(scaleX: 1, y: 0)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: UIViewAnimationOptions(), animations: {
            self.alpha=1
            self.view.transform=CGAffineTransform.identity
        }) { (b) in
            // self.view.layer.anchorPoint=CGPointMake(0.5, 0.5)
            
        }
        if anchor.isKind(of: UIButton.self) && !anchor.isKind(of: (NSClassFromString("UINavigationButton")!)){
            self.anchor=anchor as? UIButton
            self.anchor?.isSelected=true
        }
        
    }
    
    
    
    
    
    class func dialogWith()->Self{
        let dialog = self.init(frame:CGRect(x: 0, y: 0, width: 0, height: 0))
        
        //(dialog as BaseDialog).backgroundColor=iColor(0x88000000)
        return dialog
    }
    func show(_ vc:UIViewController?=nil,basev:UIView?=nil,anchor:UIView?=nil)->Self{
        var view:UIView? = nil
        if let nav = vc?.navigationController {
            view = nav.view
        }else if let vc = vc{
            view=vc.view
        }else if let basev = basev{
            view=basev
        }else{
            view = frontestWindow()
        }
        view!.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        if let anchor = anchor{
            drowDown(anchor)
        }else{
            showCenter()
        }
        self.afterShow()
        
        return self
    }
    
    
    func afterShow(){
        
    }
}


