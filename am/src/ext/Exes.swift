

//
//  Exes.swift
//  day42-swiftbeginning
//
//  Created by apple on 15/12/3.
//  Copyright © 2015年 yf. All rights reserved.
//

import UIKit



let iScr = UIScreen.mainScreen()
var iScrW:CGFloat {
get{
    return iScr.bounds.size.width
}
}
var iScrH:CGFloat{
get{
    return iScr.bounds.size.height
}
}
let iBundle = NSBundle.mainBundle()
let iInfoDict:[String:AnyObject] = iBundle.infoDictionary!
let iLoop = NSRunLoop.mainRunLoop()
let iApp = UIApplication.sharedApplication()
let iAppDele = iApp.delegate as! AppDelegate
let iFm = NSFileManager.defaultManager()
let iScale=UIScreen.mainScreen().scale
let iNotiCenter = NSNotificationCenter.defaultCenter()

let iVersion = Float(UIDevice.currentDevice().systemVersion)

let iStBH:CGFloat = 20
let iNavH:CGFloat = 44
let iTopBarH:CGFloat = (iStBH+iNavH)
let iTabBarH:CGFloat = 49
let namespace:String = NSBundle.mainBundle().infoDictionary!["CFBundleName"] as! String


let iBaseURL:String = "http://"
//let iBaseURL:String "http://"


func iCommonLog2(desc:AnyObject,file:String=#file,line:Int=#line,fun:String=#function) {
    iPrint(String(format: "file：%@    line：%d    function：%@     desc：\(desc)",file,line,fun))
}


func iCommonLog(desc:AnyObject,file:String=#file,line:Int=#line){
    iPrint(String(format:"class:%@   line:%d   desc:\(desc)",file.componentsSeparatedByString("/").last ?? "",line))
}

func iPrint(items: Any...){
    //    #if DEBUG
    print(items)
    //    #endif
}

func idelay(sec:NSTimeInterval,asy:Bool,cb:(()->())){
    dispatch_after(dispatch_time(0, Int64(sec * 1e9)),asy ? dispatch_get_global_queue(0, 0):dispatch_get_main_queue(),cb)
}



func iResUrl(res:String,bundle:NSBundle=NSBundle.mainBundle())->NSURL?{
   return  bundle.URLForResource(res, withExtension: nil)
}

func iRes(res:String,bundle:NSBundle=NSBundle.mainBundle())->String?{
    return bundle.pathForResource(res, ofType: nil)
}
func iBundle(iden:String)->NSBundle?{
    if let path = iRes(iden){
        
        return NSBundle(path: path )
    }
    return nil
}

func iPref(name:String?=nil)->NSUserDefaults?{
    return NSUserDefaults(suiteName: name)
}


func iColor(r:Int,_ g:Int,_ b:Int,_ a:CGFloat=1)->UIColor{
    return UIColor(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: a)
}
func iColor(val:Int64)->UIColor{
    return UIColor(red: CGFloat((val & 0xff0000)>>16)/255, green: CGFloat((val & 0xff00)>>8)/255, blue: CGFloat((val & 0xff))/255, alpha: CGFloat(Int(val) >>> 24)/255)
}

func iColor(hexstri:String?)->UIColor?{
    guard let hexstri = hexstri else{
        return nil
    }
    let hexstr=hexstri.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
    var from:Int=0
    var to:Int=2
    var fs:[Int]=[0,0,0,1]
    var i:Int=0
    while(from<hexstr.len-1&&from<8){
        if(hexstr.len-from<to){to=hexstr.len-from}
        var val:UInt32 = 0
        (NSScanner.localizedScannerWithString((hexstr as NSString).substringWithRange(NSMakeRange(from, to))) as! NSScanner).scanHexInt(&val)
        fs[i]=Int(val)
        i += 1
        from+=to
    }
    return iColor(fs[0],fs[1],fs[2],CGFloat(fs[3]))
}

func iimg(color:UIColor)->UIImage{
    let rect=CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
    let context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context!, color.CGColor);
    CGContextFillRect(context!, rect)
    let img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img!;
}

func irandColor()->UIColor{
    return iColor(irand(256), irand(256), irand(256))
}
func irand(base:UInt32=UInt32.max)->Int{
    return Int(arc4random_uniform(base))
}

func localizeStr(str:String)->String{
   
    let temp1 = str.stringByReplacingOccurrencesOfString("\\u", withString: "\\U")
    let temp2=temp1.stringByReplacingOccurrencesOfString("\"", withString: "\\\"")
    let temp3 = "\"\(temp2)\""
    
    let data = temp3.dataUsingEncoding(4)
    let str = NSPropertyListSerialization.propertyListFromData(data!, mutabilityOption: NSPropertyListMutabilityOptions.Immutable, format: nil, errorDescription: nil)!.description
    return str
}



func iFont(size:CGFloat)->UIFont{
    return UIFont.systemFontOfSize(size)
}

func ibFont(size:CGFloat)->UIFont{
    return UIFont.boldSystemFontOfSize(size)
}

func iUrl(str:String?)->NSURL?{
    guard let url=str else{
        return nil
    }
    return NSURL(string: url)
}

func iReq(str:String)->NSURLRequest{
    if let url=iUrl(str){
        return NSURLRequest(URL: url)
    }
    return NSURLRequest()
}
func imReq(str:String)->NSMutableURLRequest{
    guard let url=iUrl(str) else{
        return NSMutableURLRequest()
    }
    return NSMutableURLRequest(URL: url)
}

func iData(name:String?)->NSData?{
    
    guard let url=iUrl(name) else{
        return nil
    }
    return  NSData(contentsOfURL:url)
}

func iData4F(name:String?)->NSData?{
    guard let name=name else{
        return nil
    }
    return NSData(contentsOfFile:name)
}

func imgFromData(name:String?)->UIImage?{
    guard let data=iData(name) else{
        return nil
    }
    return   UIImage(data: data)
}


func  imgFromData4F(name:String?)->UIImage? {
    guard let data=iData4F(name) else{
        return nil
    }
    return UIImage(data: data)
}


func imgFromF(name:String?)->UIImage?{
    guard let name=name else{
        return nil
    }
    return UIImage(contentsOfFile: name)
}
func iimg(name:String?)->UIImage?{
    guard let name=name else{
        return nil
    }
    if(name.hasSuffix(".9")){
        return UIImage(named: name)?.convertAndroidPointNine()
    }
    return UIImage(named: name)
}
func idxof(ary:[String],tar:String?)->Int{
    if let tar = tar{
        for (i,str) in ary.enumerate(){
            if str == tar{
                return i
            }
        }
    }
    return -1
}

func prosWithClz(clz:AnyClass)->[String]{
    var count:UInt32 = 0
    let propertiesInAClass:UnsafeMutablePointer<Ivar> = class_copyIvarList(clz, &count)
    
    var ary:[String]=[]
    for i in 0..<count {
        let  pro:objc_property_t = propertiesInAClass[Int(i)]
        if let str = NSString(CString: ivar_getName(pro), encoding: NSUTF8StringEncoding) as? String{
            ary.append(str)
        }
    }
    return ary;
}
func allprosWithClz(clz:AnyClass)->[String]{
    var count:UInt32 = 0
    let propertiesInAClass:UnsafeMutablePointer<objc_property_t> = class_copyPropertyList(clz, &count)
    
    var ary:[String]=[]
    for i in 0..<count {
        let  pro:objc_property_t = propertiesInAClass[Int(i)]
        if let str = NSString(CString: property_getName(pro), encoding: NSUTF8StringEncoding) as? String{
            ary.append(str)
        }
    }
    return ary;

}




func iRes4Ary(path:String,bundle:NSBundle=NSBundle.mainBundle())->[AnyObject]{
    return   NSArray(contentsOfFile: iRes(path,bundle: bundle)!) as! [AnyObject]
}

func iRes4Dic(path:String,bundle:NSBundle=NSBundle.mainBundle())->[String:AnyObject]{
    return NSDictionary(contentsOfFile: iRes(path,bundle: bundle)!) as! Dictionary
}
func iVCFromStr(name:String?)->UIViewController?{
    if let name = name{
        if let type = NSClassFromString(namespace + "." + name) as? UIViewController.Type{
            return type.init()
        }
    }
    return nil
}
func iClassFromStr(name:String?)->NSObject?{
    if let name = name{
        return (NSClassFromString(name) as! NSObject.Type).init()
    }
    return nil
}

func iTimer(inteval:NSTimeInterval,tar:AnyObject,sel:Selector)->NSTimer{
    let timer = NSTimer(timeInterval: inteval, target: tar, selector: sel, userInfo: nil, repeats: true)
    iLoop.addTimer(timer, forMode: NSRunLoopCommonModes)
    return timer
}
func iDisLin(tar:AnyObject,sel:Selector)->CADisplayLink{
    let dislin = CADisplayLink(target: tar, selector: sel)
    dislin.addToRunLoop(iLoop, forMode: NSRunLoopCommonModes)
    return dislin
}
func isBlank(str:String?)->Bool{
    if let str = str {
        return isBlank(str)
    }
    return true
}
func isBlank(str:String)->Bool{
    return str.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) == ""
}

func dispatchDelay(sec:CGFloat,cb:()->()){
    dispatch_after(dispatch_time(0, Int64(sec * 1e9)),dispatch_get_main_queue(),cb)
}


func empty(str:String?)->Bool{
    if let s = str where s != ""{
        return false
    }
    return true
}

extension UIView{
    
    func rmAllSubv(){
        for v in self.subviews{
            v.removeFromSuperview()
        }
    }
    
    var x:CGFloat{
        get{
            return frame.origin.x
        }
        set{
            frame.origin.x=newValue
        }
    }
    
    var y:CGFloat{
        get{
            return frame.origin.y
        }
        set{
            frame.origin.y=newValue
        }
    }
    
    var r:CGFloat{
        get{
            return frame.origin.x+frame.width
        }
        set{
            frame.origin.x=newValue-frame.width
        }
    }
    
    var b:CGFloat{
        get{
            return frame.origin.y+frame.height
        }
        set{
            frame.origin.y=newValue-frame.height
        }
    }
    
    
    var x2:CGFloat{
        get{
            return x
        }
        set{
            frame.size.width += frame.origin.x-newValue
            frame.origin.x=newValue
        }
    }
    
    var y2:CGFloat{
        get{
            return y
        }
        set{
            frame.size.height += frame.origin.y-newValue
            frame.origin.y=newValue
        }
    }
    
    var r2:CGFloat{
        get{
            return r
        }
        set{
            frame.size.width=newValue-frame.origin.x
        }
    }
    
    var b2:CGFloat{
        get{
            return b
        }
        set{
            frame.size.height=newValue-frame.origin.y
        }
    }
    
    
    var w:CGFloat{
        get{
            return frame.width
        }
        set{
            frame.size.width=newValue
        }
    }
    
    var h:CGFloat{
        get{
            return frame.height
        }
        set{
            frame.size.height=newValue
        }
    }
    
    
    
    var cx:CGFloat{
        get{
            return center.x
        }
        set{
            center.x=newValue
        }
    }
    
    
    var cy:CGFloat{
        get{
            return center.y
        }
        set{
            center.y=newValue
        }
    }
    
    
    
    
    var ic:CGPoint{
        return CGPoint(x: w * 0.5, y: h * 0.5)
    }
    
    var icx:CGFloat{
        return w*0.5
    }
    var icy:CGFloat{
        return h*0.5
    }
    
    var size:CGSize{
        get{
            return frame.size
        }
        set{
            frame.size=newValue
        }
    }
    
    
    var ori:CGPoint{
        get{
            return frame.origin
        }
        set{
            frame.origin=newValue
        }
    }
    
    
}

extension CALayer{
    var x:CGFloat{
        get{
            return frame.origin.x
        }
        set{
            frame.origin.x=newValue
        }
    }
    
    var y:CGFloat{
        get{
            return frame.origin.y
        }
        set{
            frame.origin.y=newValue
        }
    }
    
    var r:CGFloat{
        get{
            return frame.origin.x+frame.width
        }
        set{
            frame.origin.x=newValue-frame.width
        }
    }
    
    var b:CGFloat{
        get{
            return frame.origin.y+frame.height
        }
        set{
            frame.origin.y=newValue-frame.height
        }
    }
    
    
    var x2:CGFloat{
        get{
            return x
        }
        set{
            frame.size.width += frame.origin.x-newValue
            frame.origin.x=newValue
        }
    }
    
    var y2:CGFloat{
        get{
            return y
        }
        set{
            frame.size.height += frame.origin.y-newValue
            frame.origin.y=newValue
        }
    }
    
    var r2:CGFloat{
        get{
            return r
        }
        set{
            frame.size.width=newValue-frame.origin.x
        }
    }
    
    var b2:CGFloat{
        get{
            return b
        }
        set{
            frame.size.height=newValue-frame.origin.y
        }
    }
    
    
    var w:CGFloat{
        get{
            return frame.width
        }
        set{
            frame.size.width=newValue
        }
    }
    
    var h:CGFloat{
        get{
            return frame.height
        }
        set{
            frame.size.height=newValue
        }
    }
    
    
    
    var cx:CGFloat{
        get{
            return position.x
        }
        set{
            position.x=newValue
        }
    }
    
    
    var cy:CGFloat{
        get{
            return position.y
        }
        set{
            position.y=newValue
        }
    }
    
    
    
    
    var ic:CGPoint{
        return CGPoint(x: w * 0.5, y: h * 0.5)
    }
    
    var icx:CGFloat{
        return w*0.5
    }
    var icy:CGFloat{
        return h*0.5
    }
    
    var size:CGSize{
        get{
            return frame.size
        }
        set{
            frame.size=newValue
        }
    }
    
    
    var ori:CGPoint{
        get{
            return frame.origin
        }
        set{
            frame.origin=newValue
        }
    }
}





extension UIColor{
    
    class func randColor()->UIColor{
        return UIColor(red: randF(255.0), green: randF(255.0), blue: randF(255.0), alpha: 1)
    }
    class  func randF(base:CGFloat )->CGFloat{
        let i = UInt32(base) + 1
        return CGFloat(arc4random()%i)/base
    }
    class  func rand(base:Int)->Int{
        return Int(arc4random()%UInt32(base+1))
    }
    
    
}

extension Array{
    subscript(fir:Int,sec:Int,other:Int...)-> Array<Element>{
        get{
            assert(fir < self.count && sec < self.count, "idx out of range")
            var res = Array<Element>()
            res.append(self[fir])
            res.append(self[sec])
            for i in other {
                assert(i < self.count,"idx out of range")
                res.append(self[i])
            }
            
            return res
        }
        set{
            assert(fir < self.count && sec < self.count, "idx out of range")
            self[fir] = newValue[0]
            self[sec] = newValue[1]
            for (idx,i) in other.enumerate(){
                assert(i < self.count, "idx out of range")
                self[i] = newValue[idx]
            }
        }
    }
    
    mutating func removeAtIdxes(idxes:Set<Int>){
        var ary = [Int]()
        for idx in idxes{
            ary.append(idx)
        }
        ary.sortInPlace { (left, right) -> Bool in
            return left > right
        }
        for i in ary {
            removeAtIndex(i)
        }
        
    }
}
extension Dictionary{
    
    subscript(fir:Key,sec:Key,other:Key...)->Array<Value>{
        get{
            var res = Array<Value>()
            let keys = self.keys
            if keys.contains(fir){
                res.append(self[fir]!)
            }
            if keys.contains(sec){
                res.append(self[sec]!)
            }
            for k in other{
                if keys.contains(k){
                    res.append(self[k]!)
                }
            }
            return res
        }
        
        set{
            self[fir]=newValue[0]
            self[sec]=newValue[1]
            for (i,k) in other.enumerate(){
                self[k]=newValue[i+2]
            }
        }
    }
}
extension NSDictionary{
    subscript(fir:String,sec:String,other:String...)->Array<AnyObject>{
        get{
            var res = Array<AnyObject>()
            let keys = self.allKeys as! [String]
            if keys.contains(fir){
                res.append(self[fir]!)
            }
            if keys.contains(sec){
                res.append(self[sec]!)
            }
            for k in other{
                if keys.contains(k){
                    res.append(self[k]!)
                }
            }
            return res
        }
        
        set{
            self.setValue(newValue[0], forKey: fir)
            self.setValue(newValue[1], forKey: sec)
            for (i,k) in other.enumerate(){
                self.setValue(newValue[i+2], forKey: k)
            }
        }
    }
    
    
    
}



extension NSArray{
    subscript(fir:Int,sec:Int,other:Int...)-> Array<AnyObject>{
        get{
            assert(fir < self.count && sec < self.count, "idx out of range")
            var res = Array<AnyObject>()
            res.append(self[fir])
            res.append(self[sec])
            for i in other {
                assert(i < self.count,"idx out of range")
                res.append(self[i])
            }
            
            return res
        }
        set{
            assert(fir < self.count && sec < self.count, "idx out of range")
            assert(self.isKindOfClass(NSMutableArray), "idx out of range")
            if let ma = self as? NSMutableArray{
                ma.insertObject(newValue[0], atIndex: 0)
                ma.insertObject(newValue[1], atIndex: 1)
                for (idx,i) in other.enumerate(){
                    assert(i < self.count, "idx out of range")
                    ma.insertObject(newValue[idx], atIndex: i)
                }
                
            }
            
        }
    }
}

extension NSObject{
    convenience init(dict:[String:AnyObject]?){
        self.init()
        if let dict = dict{
            setValuesForKeysWithDictionary(dict)
        }
    }
    
    func convert2dict()->[String:AnyObject]{
        return self.dictionaryWithValuesForKeys(prosWithClz(self.dynamicType))
    }
}



extension String{
    
    var len:Int{
        return characters.count
    }
    func strByAp2Cache()->String{
        return iFileUtil.cachePath().stringByAppendingString("/\(self)")
    }
    func strByAp2Doc()->String{
        return iFileUtil.docPath().stringByAppendingString("/\(self)")
    }
    func strByAp2Temp()->String{
        return iFileUtil.tempPath().stringByAppendingString("/\(self)")
    }
    func urlEncoded()->String{
        return stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
    }
    
    func equalIgnoreCase(instr:String?)->Bool{
        
        guard let str = instr else{
            return false
        }
        
        return (str as NSString).lowercaseString == (self as NSString).lowercaseString
        
        
    }
    
    
    
    func sizeWithFont(font:UIFont)->CGSize{
        return (self as NSString).sizeWithAttributes([NSFontAttributeName:font])
    }
    
    static func isDecimal(deci:String?,scale:Int)->Bool {
        if empty(deci){
            return false
        }
        return deci =~ "^[0-9]*\\.?[0-9]{0,\(scale)}$"
        
    }
    
    static func  isNumber(number:String?) ->Bool {
        if empty(number){
            return false
        }
        return number =~ "^\\d+$"
    }
    static func isPhoneNum(phone:String?) -> Bool{
        if empty(phone){
            return false
        }
        return phone =~ "^[1]([3][0-9]{1}|59|56|58|88|89|86|85|87)[0-9]{8}$"
    }
    
    
    static func isPwd(pwd:String?)->Bool{
        if empty(pwd){
            return false
        }
        return pwd =~ "^\\w{6,20}$"
    }
    static func isEmail(email:String?)->Bool{
        if empty(email){
            return false
        }
        return email =~ "^(\\w)+(\\.\\w+)*@[-\\w]+((\\.\\w{2,3}){1,3})$"
    }
    
    
    func toPinyin()->String{
        let mut = NSMutableString(string: self) as CFMutableString
        
        if CFStringTransform(mut, nil, kCFStringTransformMandarinLatin, false){
            CFStringTransform(mut, nil, kCFStringTransformStripDiacritics, false)
        }
        return (mut as NSMutableString).description
    }
    func phonetic()->String{
        if self.len>0{
            let mut = NSMutableString(string: self) as CFMutableString
            var ran:CFRange=CFRangeMake(0, 1)
            CFStringTransform(mut, &ran, kCFStringTransformMandarinLatin, false)
            CFStringTransform(mut, &ran, kCFStringTransformStripDiacritics, false)
            var c=((mut as NSMutableString).description as NSString).characterAtIndex(0)
            if (c>=65 && c<=90) || (c>=97&&c<=122){
                return NSString(characters: &c, length: 1) as String
            }
        }
        return "#"
    }
    func upPhonetic()->String{
        return self.phonetic().uppercaseString
    }
}





