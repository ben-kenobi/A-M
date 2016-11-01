//
//  TouchIDMan.swift
//  am
//
//  Created by apple on 16/11/1.
//  Copyright © 2016年 apple. All rights reserved.
//

import Foundation
import LocalAuthentication


class TouchIDMan {
    
    
    
    
    static func bioAuth(_ sucCB:(()->())?){
        DispatchQueue.main.async {
            let tup = TouchIDMan.isTouchIdAvailableOnDevice()
            if tup.0{
                let con = LAContext()
                var err:NSError? = nil
                if con.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &err){
                    con.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "使用系统指纹验证", reply: { (suc, err) in
                        if suc {
                            DispatchQueue.main.async {
                                sucCB?()
                            }
                            return
                        }
                        let err = err as! LAError
                        if err.code == LAError.authenticationFailed{
                            self.bioAuth(sucCB)
                        }else if err.code == LAError.touchIDLockout{
                            self.ownerAuth(sucCB)
                        }
                    })
                }else{
                    if err!.code == LAError.Code.touchIDLockout.rawValue{
                        self.ownerAuth(sucCB)
                    }
                }
            }else{
                iPop.toast("指纹验证不可用\n\(tup.1)")
            }
        }
        
    }
    static func ownerAuth(_ sucCB:(()->())?){
        DispatchQueue.main.async {
            let con = LAContext()
            var err:NSError? = nil
            if con.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: &err){
                con.evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: "输入密码来解锁指纹验证", reply: { (suc, err) in
                    if let err = err{
                        iPop.toastOnMain(err.localizedDescription)
                    }else if suc{
                        self.bioAuth(sucCB)
                    }
                })
            }else{
                iPop.toast(err!.localizedDescription)
            }
            
        }
    }
    
    
    class func isBioAuthEnable(_ name:String)->Bool{
        if !TouchIDMan.isTouchIdAvailableOnDevice().0{
            return false
        }
        return iPref()?.bool(forKey: "bioAuth_\(name)") ?? false
    }
    class func toggleBioAuthAceess(_ name:String)->(Bool,String){
        let tup = TouchIDMan.isTouchIdAvailableOnDevice()
        if !tup.0{
            return tup
        }
        iPref()?.set(!isBioAuthEnable(name), forKey: "bioAuth_\(name)")
        return (true,"")
    }

    
    
    
    static func code2msg(_ code:Int)->String{
        
        switch code {
        case LAError.Code.authenticationFailed.rawValue:
            return "验证失败"
        case LAError.Code.userCancel.rawValue:
            return "取消验证"
        case LAError.Code.userFallback.rawValue:
            return "使用密码方式验证"
        case LAError.Code.systemCancel.rawValue:
            return "验证被中断"
        case LAError.Code.passcodeNotSet.rawValue:
            return "TouchID未设置"
        case LAError.Code.touchIDNotAvailable.rawValue:
            return "不支持TouchID"
        case LAError.Code.touchIDNotEnrolled.rawValue:
            return "不存在有效的指纹"
        case LAError.Code.touchIDLockout.rawValue:
            return "验证失败5次,指纹验证被锁定"
        case LAError.Code.appCancel.rawValue:
            return "取消验证"
        case LAError.Code.invalidContext.rawValue:
            return "无效的上下文"
        default:return "验证失败"
            
        }
    }
    static func touchIdUnavailableCode(_ code:Int)->Bool{
        return code == LAError.Code.passcodeNotSet.rawValue ||
            code == LAError.Code.touchIDNotAvailable.rawValue ||
        code == LAError.Code.touchIDNotEnrolled.rawValue
    }
    
    static func isTouchIdAvailableOnDevice()->(Bool,String){
        if iVersion.numericCompare("8.0") < 0 {
            return (false,"IOS系统版本低于8.0,不支持指纹验证")
        }
        let con = LAContext()
        var err:NSError? = nil
        if !con.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &err){
            if touchIdUnavailableCode(err!.code){
                return (false,code2msg(err!.code))
            }
        }
        return (true,"")
    }
    
    
    
}

/*// Authentication was not successful, because user failed to provide valid credentials.
case authenticationFailed


/// Authentication was canceled by user (e.g. tapped Cancel button).
case userCancel


/// Authentication was canceled, because the user tapped the fallback button (Enter Password).
case userFallback


/// Authentication was canceled by system (e.g. another application went to foreground).
case systemCancel


/// Authentication could not start, because passcode is not set on the device.
case passcodeNotSet


/// Authentication could not start, because Touch ID is not available on the device.
case touchIDNotAvailable


/// Authentication could not start, because Touch ID has no enrolled fingers.
case touchIDNotEnrolled


/// Authentication was not successful, because there were too many failed Touch ID attempts and
/// Touch ID is now locked. Passcode is required to unlock Touch ID, e.g. evaluating
/// LAPolicyDeviceOwnerAuthenticationWithBiometrics will ask for passcode as a prerequisite.
@available(iOS 9.0, *)
case touchIDLockout


/// Authentication was canceled by application (e.g. invalidate was called while
/// authentication was in progress).
@available(iOS 9.0, *)
case appCancel


/// LAContext passed to this call has been previously invalidated.
@available(iOS 9.0, *)
case invalidContext
 */
 
 
