//
//  MenuUtil.swift
//  am
//
//  Created by apple on 16/5/19.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit
public enum NavMenu : Int {
    case done
    case cancel
    case edit
    case save
    case add
    case flexibleSpace
    case fixedSpace
    case compose
    case reply
    case action
    case organize
    case bookmarks
    case search
    case refresh
    case stop
    case camera
    case trash
    case play
    case pause
    case rewind
    case fastForward
    case undo
    case redo
    case pageCurl
    case more
}
class ComUI{

   
    static func moreItem(_ target:AnyObject,sel:Selector)->UIBarButtonItem{
        let item = UIBarButtonItem(image: iimg("ic_menu_moreoverflow_normal_holo_light"), style: UIBarButtonItemStyle.plain, target: target, action:sel)
        item.tag=NavMenu.more.rawValue
        return item
    }
    static func comBtn1(_ tar:AnyObject,sel:Selector,title:String)->UIButton{
        return UIButton(frame: nil,  title: title, font: ibFont(17), titleColor: iColor(0xffffffff), titleHlColor: iColor(0xffeeeeee), bgimg: iimg("blue_noselect.9"), hlbgimg: iimg("gray_noselect.9"),corner: 7, bordercolor: iConst.khakiBg, borderW: 1, tar: tar, action: sel, tag: 0)
       
        
    }
    static func comTitleLab(_ title:String)->UILabel{
        return   UILabel(frame: nil, txt: "\(title)", color:iConst.orgTitCol, font: ibFont(17), align: NSTextAlignment.left, line: 1, bgColor: UIColor.white)
        
    }
    static func dropBtn(_ title:String,tar:AnyObject?,sel:Selector,tag:Int)->UIButton{
        let b = DropBtn( img: iimg("triangle_down_blue"), title: title, font: ibFont(18), titleColor: iColor(0xff5555aa), bgimg: iimg("lightblue_noselect.9"), hlbgimg: iimg("button_select.9"),  corner: 4, bordercolor: iColor(0xffdddddd), borderW: 1, tar: tar, action: sel, tag: tag)
        b.setBackgroundImage(iimg("button_select.9"), for: UIControlState.selected)
        return b
        
    }
    static func comTitleView(_ title:String)->UIView{
        let view = UIView()
        let lab = comTitleLab(title)
        view.addSubview(lab)
        let divider = UIView()
        divider.backgroundColor=iColor(0xff33ff33)
        view.addSubview(divider)
        divider.snp_makeConstraints { (make) in
            make.bottom.left.right.equalTo(0)
            make.height.equalTo(2)
        }
        lab.snp_makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.bottom.equalTo(divider.snp_top)
        }
        return view
    }
    static func comDropTitleView(_ title:String,dropTitle:String,tar:AnyObject?,sel:Selector,labtag:Int,droptag:Int)->UIButton{
        let view = UIButton()
        view.setBackgroundImage(iimg(iColor(0xffffffff)), for: UIControlState())
        view.setBackgroundImage(iimg(iConst.khakiBg), for: UIControlState.highlighted)
        let lab = comTitleLab(title)
        lab.backgroundColor=UIColor.clear
        view.addSubview(lab)
        lab.tag=labtag
        let divider = UIView()
        divider.backgroundColor=iColor(0xff33ff33)
        view.addSubview(divider)
        let drop = dropBtn(dropTitle, tar: tar, sel: sel, tag: droptag)
        view.addSubview(drop)
        divider.snp_makeConstraints { (make) in
            make.bottom.left.right.equalTo(0)
            make.height.equalTo(2)
        }
        drop.snp_makeConstraints { (make) in
            make.right.equalTo(-5)
            make.top.equalTo(4)
            make.bottom.equalTo(-7)
            make.width.equalTo(150)
        }
        lab.snp_makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(10)
            make.right.equalTo(drop.snp_left).offset(-8)
            make.bottom.equalTo(divider.snp_top)
        }
        return view
    }
    
    static func comTF1(_ indica:String)->ClearableTF{
       let tf = ClearableTF()
        tf.placeholder=indica
        tf.disabledBackground=iimg(iColor(0x00ffffff))
        return tf
    }
    
   

}



class DropBtn:UIButton{
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.r=self.w-10
        titleLabel?.x=10
    }
}

class ClearableTF:UITextField{
    
    var onTxtChangeCB:((_ tf:ClearableTF)->())?
    
    lazy var btn:UIButton={
        let btn=UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20), title: "X", font: iFont(17), titleColor: iColor(0xffffffff), titleHlColor: iColor(0xffffffff), bgimg: iimg("button_select.9"), hlbgimg: iimg("lightblue_noselect.9"),corner: 10, bordercolor: iColor(0xffffffff), borderW: 1, tar: self, action:#selector(self.onClear), tag: 0)
        btn.isHidden=true
        return btn
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        let tf = self
        tf.background=iimg("editbox_background_normal.9")
        tf.disabledBackground=nil
        tf.leftView=UIView(frame: CGRect(x: 0, y: 0, width: 9, height: 0))
        tf.leftViewMode = .always
        tf.rightViewMode = .whileEditing
        let rv=UIView(frame: CGRect(x: 0, y: 0, width: 27, height: 20))
        tf.rightView = rv
        
        rv.addSubview(btn)
        iNotiCenter.addObserver(self, selector: #selector(self.onTextChanged(_:)), name: NSNotification.Name.UITextFieldTextDidChange, object: self)
        addObserver(self, forKeyPath: "enabled", options: NSKeyValueObservingOptions.old, context: nil)
        addObserver(self, forKeyPath: "text", options: NSKeyValueObservingOptions.old, context: nil)
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath! == "enabled"{
            let ph = value(forKeyPath: "_placeholderLabel") as? View
            ph?.isHidden = !isEnabled
        }else if keyPath! == "text"{
            onTextChanged(nil)
        }
        
    }
    
   func  onClear(){
        text=""
    }
   
    func onTextChanged(_ noti:Notification?){
        btn.isHidden = isBlank(text)
        onTxtChangeCB?(self)
    }
    
    deinit{
        iNotiCenter.removeObserver(self)
        removeObserver(self, forKeyPath: "enabled")
        removeObserver(self, forKeyPath: "text")

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
