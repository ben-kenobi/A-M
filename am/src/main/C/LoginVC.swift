//
//  LoginVC.swift
//  am
//
//  Created by apple on 16/5/16.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginVC: BaseVC {
    let bgmap = [iConst.ACCOUNT:"login0",iConst.FILESYSTEM:"login1",iConst.CONTACTS:"login2"]
    
    var name:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let bg = bgmap[name ?? ""] {
            view.layer.contents=iimg(bg)?.cgImage
            
        }
        view.addSubview(pwd)
        pwd.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.bottom).multipliedBy(0.3)
            make.left.equalTo(view.snp.right).multipliedBy(0.1)
            make.height.equalTo(44)
            make.width.equalTo(view.snp.width).multipliedBy(0.65)
        }
        view.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.top.height.equalTo(pwd)
            make.left.equalTo(pwd.snp.right)
            make.width.equalTo(52)
        }
        
        if TouchIDMan.isBioAuthEnable(name!){
            TouchIDMan.bioAuth({ 
                self.pwd.text=CommonService.getAccessKey()
                self.onClick(self.btn)
            })
            
            btn.isEnabled=false
            idelay(2, asy: false, cb: { 
                self.btn.isEnabled=true
            })
        }else{
            pwd.becomeFirstResponder()
        }
        
    }
    
    
    
    lazy var pwd:UITextField = {
        let pwd = UITextField(frame: nil, bg: iColor(255, 255, 255, 0.3), corner: 0, bordercolor: iColor(0, 0, 0, 0.3), borderW: 0.5)
        pwd.leftView=UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        pwd.leftViewMode = UITextField.ViewMode.always
        pwd.isSecureTextEntry=true
        pwd.returnKeyType=UIReturnKeyType.go
        pwd.delegate=self
        return pwd
        
    }()
    lazy var btn:UIButton = {
        
        let btn = UIButton(frame: nil, img: iimg("ic_launcher"),bgimg: iimg(iColor(255, 255, 255, 0.4)), hlbgimg: iimg(iColor(0,0,0,0.2)), tar: self, action:#selector(self.onClick(_:)))
        btn.addCurve(tl: (false,0), tr: (true,8), br: (true,8), bl: (false,0), bounds: CGRect(x:0,y:0,width:52,height:44))
        btn.imageView?.contentMode = .scaleAspectFit
        btn.adjustsImageWhenDisabled=false
        return btn
    }()
    
    
    @objc func onClick(_ sender:UIView){
        if (sender == btn) {
            let pwdtext = pwd.text ?? ""
            if (isBlank(pwdtext) || !CommonService.login(pwdtext)){
                dismiss(animated: true, completion: nil)
                return;
            }
            iNotiCenter.post(name: Notification.Name(rawValue: updateHomeVCNoti), object: name)
            CommonUtils.setAccessKey(pwdtext)
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        pwd.resignFirstResponder()
    }
    
}


extension LoginVC:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        onClick(btn)
        return true
    }
    
   
    
}
