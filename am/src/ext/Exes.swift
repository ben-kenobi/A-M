

//
//  Exes.swift
//  day42-swiftbeginning
//
//  Created by apple on 15/12/3.
//  Copyright © 2015年 yf. All rights reserved.
//

import UIKit



let iScr = UIScreen.main
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
let iBundle = Bundle.main
let iInfoDict:[String:Any] = iBundle.infoDictionary!
let iLoop = RunLoop.main
let iApp = UIApplication.shared
let iAppDele = iApp.delegate as! AppDelegate
let iFm = FileManager.default
let iScale=UIScreen.main.scale
let iNotiCenter = NotificationCenter.default

let iVersion = Float(UIDevice.current.systemVersion)

let iStBH:CGFloat = 20
let iNavH:CGFloat = 44
let iTopBarH:CGFloat = (iStBH+iNavH)
let iTabBarH:CGFloat = 49
let namespace:String = Bundle.main.infoDictionary!["CFBundleName"] as! String


let iBaseURL:String = "http://"
//let iBaseURL:String "http://"


func iCommonLog2(_ desc:Any,file:String=#file,line:Int=#line,fun:String=#function) {
    iPrint(String(format: "file：%@    line：%d    function：%@     desc：\(desc)",file,line,fun))
}


func iCommonLog(_ desc:Any,file:String=#file,line:Int=#line){
    iPrint(String(format:"class:%@   line:%d   desc:\(desc)",file.components(separatedBy:"/").last ?? "",line))
    
}

func iPrint(_ items: Any...){
    //    #if DEBUG
    print(items)
    //    #endif
}

func idelay(_ sec:TimeInterval,asy:Bool,cb:@escaping (()->())){
    let queue:DispatchQueue = asy ? DispatchQueue.global():DispatchQueue.main
    queue.asyncAfter(deadline: DispatchTime.now()+sec, execute: cb)
}



func iResUrl(_ res:String,bundle:Bundle=Bundle.main)->URL?{
   return  bundle.url(forResource: res, withExtension: nil)
}

func iRes(_ res:String,bundle:Bundle=Bundle.main)->String?{
    return bundle.path(forResource: res, ofType: nil)
}
func iBundle(_ iden:String)->Bundle?{
    if let path = iRes(iden){
        
        return Bundle(path: path )
    }
    return nil
}

func iPref(_ name:String?=nil)->UserDefaults?{
    return UserDefaults(suiteName: name)
}


func iColor(_ r:Int,_ g:Int,_ b:Int,_ a:CGFloat=1)->UIColor{
    return UIColor(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: a)
}
func iColor(_ val:Int64)->UIColor{
    return UIColor(red: CGFloat((val & 0xff0000)>>16)/255, green: CGFloat((val & 0xff00)>>8)/255, blue: CGFloat((val & 0xff))/255, alpha: CGFloat(Int(val) >>> 24)/255)
}

func iColor(_ hexstri:String?)->UIColor?{
    guard let hexstri = hexstri else{
        return nil
    }
    
    let hexstr=hexstri.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines).uppercased()
    var from:Int=0
    var to:Int=2
    var fs:[Int]=[0,0,0,1]
    var i:Int=0
    while(from<hexstr.len-1&&from<8){
        if(hexstr.len-from<to){to=hexstr.len-from}
        var val:UInt32 = 0
        (Scanner.localizedScanner(with: (hexstr as NSString).substring(with: NSMakeRange(from, to))) as! Scanner).scanHexInt32(&val)
        fs[i]=Int(val)
        i += 1
        from+=to
    }
    return iColor(fs[0],fs[1],fs[2],CGFloat(fs[3]))
}

func iimg(_ color:UIColor)->UIImage{
    let rect=CGRect(x:0, y:0, width:1, height:1);
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
    let context = UIGraphicsGetCurrentContext();
    context?.setFillColor(color.cgColor)
    context?.fill(rect)
    let img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img!;
}

func irandColor()->UIColor{
    return iColor(irand(256), irand(256), irand(256))
}
func irand(_ base:UInt32=UInt32.max)->Int{
    return Int(arc4random_uniform(base))
}

func localizeStr(_ str:String)->String{
   
    let temp1 = str.replacingOccurrences(of: "\\u", with: "\\U")
    let temp2=temp1.replacingOccurrences(of:"\"", with: "\\\"")
    let temp3 = "\"\(temp2)\""
    
    let data = temp3.data(using: String.Encoding.utf8)
    let str = "\(PropertyListSerialization.propertyListFromData(data!, mutabilityOption: PropertyListSerialization.MutabilityOptions.mutableContainers, format: nil, errorDescription: nil)!)"
    return str
}



func iFont(_ size:CGFloat)->UIFont{
    return UIFont.systemFont(ofSize: size)
}

func ibFont(_ size:CGFloat)->UIFont{
    return UIFont.boldSystemFont(ofSize: size)
}
func iFUrl(_ path:String?)->URL?{
    guard let path = path else{
        return nil
    }
    return URL(fileURLWithPath: path)
}
func iUrl(_ str:String?)->URL?{
    guard let url=str else{
        return nil
    }
    return URL(string: url)
}

func iReq(_ str:String)->NSURLRequest{
    if let url=iUrl(str){
        return NSURLRequest(url: url)
    }
    return NSURLRequest()
}
func imReq(_ str:String)->NSMutableURLRequest{
    guard let url=iUrl(str) else{
        return NSMutableURLRequest()
    }
    return NSMutableURLRequest(url: url)
}

func iData(_ name:String?)->Data?{
    guard let url=iUrl(name) else{
        return nil
    }
    return  try! Data(contentsOf:url)
}

func iData4F(_ name:String?)->Data?{
    guard let url=iFUrl(name) else{
        return nil
    }
    return try! Data(contentsOf:url)
}

func imgFromData(_ name:String?)->UIImage?{
    guard let data=iData(name) else{
        return nil
    }
    return   UIImage(data: data)
}


func  imgFromData4F(_ name:String?)->UIImage? {
    guard let data=iData4F(name) else{
        return nil
    }
    return UIImage(data: data)
}


func imgFromF(_ name:String?)->UIImage?{
    guard let name=name else{
        return nil
    }
    return UIImage(contentsOfFile: name)
}
func iimg(_ name:String?,pad:CGFloat = 3)->UIImage?{
    guard let name=name else{
        return nil
    }
    if(name.hasSuffix(".9")){
        return UIImage(named: name)?.convertAndroidPointNine(pad)
    }
    return UIImage(named: name)
}
func idxof(_ ary:[String],tar:String?)->Int{
    if let tar = tar{
        for (i,str) in ary.enumerated(){
            if str == tar{
                return i
            }
        }
    }
    return -1
}

func prosWithClz(_ clz:AnyClass)->[String]{
    var count:UInt32 = 0
    let propertiesInAClass:UnsafeMutablePointer<Ivar?> = class_copyIvarList(clz, &count)
    
    var ary:[String]=[]
    for i in 0..<count {
        let  pro:objc_property_t = propertiesInAClass[Int(i)]!
        if let str = NSString(cString: ivar_getName(pro), encoding: String.Encoding.utf8.rawValue) as? String{
            ary.append(str)
        }
    }
    return ary;
}
func allprosWithClz(_ clz:AnyClass)->[String]{
    var count:UInt32 = 0
    let propertiesInAClass:UnsafeMutablePointer<objc_property_t?> = class_copyPropertyList(clz, &count)
    
    var ary:[String]=[]
    for i in 0..<count {
        let  pro:objc_property_t = propertiesInAClass[Int(i)]!
        if let str = NSString(cString: property_getName(pro), encoding: String.Encoding.utf8.rawValue) as? String{
            ary.append(str)
        }
    }
    return ary;

}




func iRes4Ary(_ path:String,bundle:Bundle=Bundle.main)->[Any]{
    let path1 = iRes(path,bundle: bundle)!
    let ary = NSArray(contentsOfFile: path1)!
    let ary2 = ary as? [Any]
    if let ary3 = ary2 {
        return ary3
    }
    return []
    
    
//    return   NSArray(contentsOfFile: iRes(path,bundle: bundle)!) as! [Any]
}

func iRes4Dic(_ path:String,bundle:Bundle=Bundle.main)->[String:Any]{
    return NSDictionary(contentsOfFile: iRes(path,bundle: bundle)!) as! Dictionary
}
func iVCFromStr(_ name:String?)->UIViewController?{
    if let name = name{
        if let type = NSClassFromString(namespace + "." + name) as? UIViewController.Type{
            return type.init()
        }
    }
    return nil
}
func iClassFromStr(_ name:String?)->NSObject?{
    if let name = name{
        return (NSClassFromString(name) as! NSObject.Type).init()
    }
    return nil
}

func iTimer(_ inteval:TimeInterval,tar:Any,sel:Selector)->Timer{
    let timer = Timer(timeInterval: inteval, target: tar, selector: sel, userInfo: nil, repeats: true)
    iLoop.add(timer, forMode: RunLoopMode.commonModes)
    return timer
}
func iDisLin(_ tar:Any,sel:Selector)->CADisplayLink{
    let dislin = CADisplayLink(target: tar, selector: sel)
    dislin.add(to: iLoop, forMode: RunLoopMode.commonModes)
    return dislin
}
func isBlank(_ str:String?)->Bool{
    if let str = str {
        return isBlank(str)
    }
    return true
}
func isBlank(_ str:String)->Bool{
    return str.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == ""
}

func dispatchDelay(_ sec:Double, cb:@escaping()->()){
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+sec, execute: cb)
}


func empty(_ str:String?)->Bool{
    if let s = str , s != ""{
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
    class  func randF(_ base:CGFloat )->CGFloat{
        let i = UInt32(base) + 1
        return CGFloat(arc4random()%i)/base
    }
    class  func rand(_ base:Int)->Int{
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
            for (idx,i) in other.enumerated(){
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
        ary.sort { (left, right) -> Bool in
            return left > right
        }
        for i in ary {
            remove(at: i)
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
            for (i,k) in other.enumerated(){
                self[k]=newValue[i+2]
            }
        }
    }
}
extension NSDictionary{
    subscript(fir:String,sec:String,other:String...)->Array<Any>{
        get{
            var res = Array<Any>()
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
            for (i,k) in other.enumerated(){
                self.setValue(newValue[i+2], forKey: k)
            }
        }
    }
    
    
    
}



extension NSArray{
    subscript(fir:Int,sec:Int,other:Int...)-> Array<Any>{
        get{
            assert(fir < self.count && sec < self.count, "idx out of range")
            var res = Array<Any>()
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
            
            assert(self.isKind(of:NSMutableArray.self), "subscript from immutablee is readonly")
            if let ma = self as? NSMutableArray{
                ma.insert(newValue[0], at: 0)
                ma.insert(newValue[1], at: 1)
                for (idx,i) in other.enumerated(){
                    assert(i < self.count, "idx out of range")
                    ma.insert(newValue[idx], at: i)
                }
                
            }
            
        }
    }
}

extension NSObject{
    convenience init(dict:[String:Any]?){
        self.init()
        if let dict = dict{
            setValuesForKeys(dict)
        }
    }
    
    func convert2dict()->[String:Any]{
        return self.dictionaryWithValues(forKeys: prosWithClz(type(of: self)))
    }
}



extension String{
    
    var len:Int{
        return characters.count
    }
    func strByAp2Cache()->String{
        return iFileUtil.cachePath().appending("/\(self)")
    }
    func strByAp2Doc()->String{
        return iFileUtil.docPath().appending("/\(self)")
    }
    func strByAp2Temp()->String{
        return iFileUtil.tempPath().appending("/\(self)")
    }
    func urlEncoded()->String{
        return addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    }
    
    func equalIgnoreCase(_ instr:String?)->Bool{
        
        guard let str = instr else{
            return false
        }
        
        return (str as NSString).lowercased == (self as NSString).lowercased
        
        
    }
    
    
    
    func sizeWithFont(_ font:UIFont)->CGSize{
        return (self as NSString).size(attributes: [NSFontAttributeName:font])
    }
    
    static func isDecimal(_ deci:String?,scale:Int)->Bool {
        if empty(deci){
            return false
        }
        return deci =~ "^[0-9]*\\.?[0-9]{0,\(scale)}$"
        
    }
    
    static func  isNumber(_ number:String?) ->Bool {
        if empty(number){
            return false
        }
        return number =~ "^\\d+$"
    }
    static func isPhoneNum(_ phone:String?) -> Bool{
        if empty(phone){
            return false
        }
        return phone =~ "^[1]([3][0-9]{1}|59|56|58|88|89|86|85|87)[0-9]{8}$"
    }
    
    
    static func isPwd(_ pwd:String?)->Bool{
        if empty(pwd){
            return false
        }
        return pwd =~ "^\\w{6,20}$"
    }
    static func isEmail(_ email:String?)->Bool{
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
            var c=((mut as NSMutableString).description as NSString).character(at: 0)
            if (c>=65 && c<=90) || (c>=97&&c<=122){
                return NSString(characters: &c, length: 1) as String
            }
        }
        return "#"
    }
    func upPhonetic()->String{
        return self.phonetic().uppercased()
    }
}





