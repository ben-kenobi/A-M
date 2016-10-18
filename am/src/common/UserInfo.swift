



//
//  UserInfo.swift
//  day-43-microblog
//
//  Created by apple on 15/12/6.
//  Copyright © 2015年 yf. All rights reserved.
//

import UIKit


class UserInfo: NSObject,NSCoding {
    static var uploadingMap:[Int:TsceneProg]=[Int:TsceneProg]()
    
    //    var welcomed:Bool=false
    var welcomed:Bool=true
    var login=false
    var remPwd=false

    

    var TID:String?
    var NAME:String?
    var token:String?
    var password:String?
    var roleId:String?
    var PHONE,EMAIL:String?
    var CREATE_DATE:String?
    var SEX:Int?
    var createUserId:String?
    var upDate:String?
    var upUserId:String?
    var delDate:String?
    var delUserId:String?
    var remark:String?
    var city:String?
    var CO1_ID:String?
    var CO1_NAME:String?
    var CO2_ID:String?
    var CO2_NAME:String?
    var town:String?
    var DEPART_NAME:String?
    var DEPART_ID:String?
    var JOB_POST_ID:String?
    var JOB_POST_NAME:String?

    
    
    class func isLogin()->Bool{
        return me.login
    }
    class func loginWithDict(dict:[String:AnyObject]){
        me.setValuesForKeysWithDictionary(dict)
        PrefUtil.putByUser("haslogin", value: "1")
        if(!shouldAutoLogin()){
            PrefUtil.putByUser("logintime",value: "\(Int(NSDate.timeIntervalSinceReferenceDate()))")
        }

        doLogin()
    }
    class func doLogin(){
        me.archive()
        me.login=true
    }
    class func doLogout(){
        me.login=false
    }
    

    
    private override init(){
        super.init()
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        password = aDecoder.decodeObjectForKey("pwd") as? String
        NAME = aDecoder.decodeObjectForKey("userName") as? String
        remPwd = aDecoder.decodeBoolForKey("remPwd")
        
    }
    
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeBool(remPwd, forKey: "remPwd")
        aCoder.encodeObject(password, forKey: "pwd")
        aCoder.encodeObject(NAME, forKey: "userName")
        
    }
 
    
  
   
}

extension UserInfo{
    
    
    @nonobjc static let file="userinfo.archive".strByAp2Doc()
    @nonobjc static var me:UserInfo=UserInfo.unarchive()
    
    
  
  
    
    
    
    
    func archive(){
//        iCommonLog(UserInfo.file)

        NSKeyedArchiver.archiveRootObject(self, toFile: UserInfo.file)
       
    }
    private class func unarchive()->UserInfo{
        if let user =  NSKeyedUnarchiver.unarchiveObjectWithFile(UserInfo.file) as? UserInfo{
            return user
        }
        
        return UserInfo()
    }
    
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    override func setValue(value: AnyObject?, forKey key: String) {
//        print(value!.description + "-----" + key)
        super.setValue(value, forKey: key)
    }
    override func valueForUndefinedKey(key: String) -> AnyObject? {
        return 0
    }
    
    override var description:String{
        get{
            return dictionaryWithValuesForKeys(["userName","userUnit","userId","token"]).description
        }
    }
    
    class func isPwdExpired()->Bool{
        return false
    }
    
    
    class func hasWelcomed()->Bool{
       
        return me.welcomed
    }
    
    class func welcomed(b:Bool){

        me.welcomed=b

    }
    
    
    
}



extension UserInfo{
    
    
    

    class func logout() {
    
        PrefUtil.putByUser("haslogin", value: "0")
        me = UserInfo()
        updateRVC()
    
    }
    class func   shouldAutoLogin()->Bool{
    return "1" == PrefUtil.getByUser("haslogin", defau: "0")
            && isautologin()
    }
    
    class func setautologin(b :Bool)->Bool{
    
        return PrefUtil.putByUser("autologin", value: b ? "1" : "0")
    }
    class func  isautologin()->Bool{
        return "1" == PrefUtil.getByUser("autologin", defau: "1")
    }
    class  func setPwdReservedDays( days:Int){
        PrefUtil.putByUser("PwdReservedDays", value: "\(days)");
    }
    class func getPwdReservedDays()->Int{
        return Int(PrefUtil.getByUser("PwdReservedDays", defau: "30"))!
    }
    
    
    class func isPwdExpire()->Bool{
        let maxspan = getPwdReservedDays()*24*60*60*1000;
        let span = Int(NSDate.timeIntervalSinceReferenceDate()) -
             Int(PrefUtil.getByUser("logintime",defau:"\(Int(NSDate.timeIntervalSinceReferenceDate()))"))!
        return  span > maxspan;
    }

    class func  getTagsList(originalText:String)->[String] {
    if (originalText == "" ) {
        return [];
    }
    var tags = [String]();
    let nsstr = originalText as NSString
    var lastidx = 0
    var indexOfComma = nsstr.rangeOfString(",", options: [], range: NSMakeRange(lastidx, nsstr.length-lastidx)).location
        var tag:String=""
    while (indexOfComma != NSNotFound) {
        tag = nsstr.substringWithRange(NSMakeRange(lastidx, indexOfComma-lastidx+1))
        lastidx=indexOfComma+1
        tags.append(tag)
        
        
        indexOfComma = nsstr.rangeOfString(",", options: [], range: NSMakeRange(lastidx, nsstr.length-lastidx)).location
    }
    
    tags.append(originalText)
    return tags;
}



class func pushChannelId(){
    if(empty(UserInfo.me.token) || empty(JPUSHService.registrationID()) ){
        return
    }
    let path = iConst.pushChannelIdUrl+"?token=" + UserInfo.me.token! + "&pushChannelId="+JPUSHService.registrationID()
    NetUtil.commonRequestJson(true, path: path, para: nil, succode: ["200"],cb:{ (data, idx) in
        iCommonLog("\(localizeStr(data.description))------------------")
    })

}

}

