

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
let iInfoDict:[String:AnyObject] = iBundle.infoDictionary! as [String : AnyObject]
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


func iCommonLog2(_ desc:AnyObject,file:String=#file,line:Int=#line,fun:String=#function) {
    iPrint(String(format: "file：%@    line：%d    function：%@     desc：\(desc)",file,line,fun))
}


func iCommonLog(_ desc:AnyObject,file:String=#file,line:Int=#line){
    iPrint(String(format:"class:%@   line:%d   desc:\(desc)",file.components(separatedBy: "/").last ?? "",line))
}

func iPrint(_ items: Any...){
    //    #if DEBUG
    print(items)
    //    #endif
}

func idelay(_ sec:TimeInterval,asy:Bool,cb:(()->())){
    (asy ? DispatchQueue.global(priority: 0):DispatchQueue.main).asyncAfter(deadline: 0 + Double(Int64(sec * 1e9)) / Double(NSEC_PER_SEC),execute: cb)
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
func iColor(_ val:Int)->UIColor{
    return UIColor(red: CGFloat((val & 0xff0000)>>16)/255, green: CGFloat((val & 0xff00)>>8)/255, blue: CGFloat((val & 0xff))/255, alpha: CGFloat(val >>> 24)/255)
}

func iimg(_ color:UIColor)->UIImage{
    let rect=CGRect(x: 0, y: 0, width: 1, height: 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
    let context = UIGraphicsGetCurrentContext();
    context?.setFillColor(color.cgColor);
    context?.fill(rect)
    let img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img!;
}

func irandColor()->UIColor{
    return iColor(irand(256), irand(256), irand(256))
}
func irand(_ base:Int=Int(UInt32.max))->Int{
    
    return Int(arc4random_uniform(UInt32(base)))
}



func iFont(_ size:CGFloat)->UIFont{
    return UIFont.systemFont(ofSize: size)
}

func ibFont(_ size:CGFloat)->UIFont{
    return UIFont.boldSystemFont(ofSize: size)
}

func iUrl(_ str:String?)->URL?{
    guard let url=str else{
        return nil
    }
    return URL(string: url)
}

func iReq(_ str:String)->URLRequest{
    if let url=iUrl(str){
        return URLRequest(url: url)
    }
    return URLRequest()
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
    return  (try? Data(contentsOf: url))
}

func iData4F(_ name:String?)->Data?{
    guard let name=name else{
        return nil
    }
    return (try? Data(contentsOf: URL(fileURLWithPath: name)))
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
func iimg(_ name:String?)->UIImage?{
    guard let name=name else{
        return nil
    }
    if(name.hasSuffix(".9")){
        return UIImage(named: name)?.convertAndroidPointNine()
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



func iRes4Ary(_ path:String,bundle:Bundle=Bundle.main)->[AnyObject]{
    return   NSArray(contentsOfFile: iRes(path,bundle: bundle)!) as! [AnyObject]
}

func iRes4Dic(_ path:String,bundle:Bundle=Bundle.main)->[String:AnyObject]{
    return NSDictionary(contentsOfFile: iRes(path,bundle: bundle)!) as! Dictionary
}
func iVCFromStr(_ name:String)->UIViewController?{
    if let type = NSClassFromString(namespace + "." + name) as? UIViewController.Type{
        return type.init()
    }
    return nil
}

func iTimer(_ inteval:TimeInterval,tar:AnyObject,sel:Selector)->Timer{
    let timer = Timer(timeInterval: inteval, target: tar, selector: sel, userInfo: nil, repeats: true)
    iLoop.add(timer, forMode: RunLoopMode.commonModes)
    return timer
}
func iDisLin(_ tar:AnyObject,sel:Selector)->CADisplayLink{
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

func dispatchDelay(_ sec:CGFloat,cb:()->()){
    DispatchQueue.main.asyncAfter(deadline: 0 + Double(Int64(sec * 1e9)) / Double(NSEC_PER_SEC),execute: cb)
}

extension UIView{
    
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



extension String{
    var len:Int{
        return characters.count
    }
    func strByAp2Cache()->String{
        return iFileUtil.cachePath() + "/\(self)"
    }
    func strByAp2Doc()->String{
        return iFileUtil.docPath() + "/\(self)"
    }
    func strByAp2Temp()->String{
        return iFileUtil.tempPath() + "/\(self)"
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
}



extension UIColor{
    
    class func randColor()->UIColor{
        return UIColor(red: randF(255.0), green: randF(255.0), blue: randF(255.0), alpha: 1)
    }
    class  func randF(_ base:CGFloat )->CGFloat{
        return CGFloat(random()%(Int(base)+1))/base
    }
    class  func rand(_ base:Int)->Int{
        return random()%(base+1)
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
    
    mutating func removeAtIdxes(_ idxes:Set<Int>){
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
    subscript(fir:String,sec:String,other:String...)->Array<AnyObject>{
        get{
            var res = Array<AnyObject>()
            let keys = self.allKeys as! [String]
            if keys.contains(fir){
                res.append(self[fir]! as AnyObject)
            }
            if keys.contains(sec){
                res.append(self[sec]! as AnyObject)
            }
            for k in other{
                if keys.contains(k){
                    res.append(self[k]! as AnyObject)
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
    subscript(fir:Int,sec:Int,other:Int...)-> Array<AnyObject>{
        get{
            assert(fir < self.count && sec < self.count, "idx out of range")
            var res = Array<AnyObject>()
            res.append(self[fir] as AnyObject)
            res.append(self[sec] as AnyObject)
            for i in other {
                assert(i < self.count,"idx out of range")
                res.append(self[i] as AnyObject)
            }
            
            return res
        }
        set{
            assert(fir < self.count && sec < self.count, "idx out of range")
            assert(self.isKind(of: NSMutableArray.self), "idx out of range")
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
    convenience init(dict:[String:AnyObject]?){
        self.init()
        if let dict = dict{
            setValuesForKeys(dict)
        }
    }
}



extension String{
    func sizeWithFont(_ font:UIFont)->CGSize{
        return (self as NSString).size(attributes: [NSFontAttributeName:font])
    }
}





