//
//  Date+Ext.swift
//  day-43-microblog
//
//  Created by apple on 15/12/12.
//  Copyright © 2015年 yf. All rights reserved.
//

import Foundation

//basic



extension NSDate{
    
    
    class func dfm(fmstr:String)->NSDateFormatter{
        let fm=NSDateFormatter()
        fm.locale=NSLocale(localeIdentifier: "en")
        fm.dateFormat = fmstr
        return fm
    }
    
    @nonobjc static var dateFm:NSDateFormatter = NSDate.dfm("yyyy-MM-dd")
    
    @nonobjc static var dateTimeFm:NSDateFormatter = NSDate.dfm("MM-dd HH:mm")
    
    @nonobjc static var timeFm:NSDateFormatter = NSDate.dfm("yyyy-MM-dd HH:mm:ss")
    
    
    @nonobjc static var timeFm2:NSDateFormatter = NSDate.dfm("yyyy-MM-dd HH:mm")
    
    
    @nonobjc static var timeFm3:NSDateFormatter = NSDate.dfm("HH:mm")
    
    
    @nonobjc static var timeFm4:NSDateFormatter = {
        let fm = NSDate.dfm("EEE MMM dd HH:mm:ss z yyyy")
        fm.locale=NSLocale(localeIdentifier:"en_US")
        return fm
    }()
    

    
    
    
    func dateFM()->String{
        return NSDate.dateFm.stringFromDate(self)
    }
    func dateTimeFM()->String{
        return NSDate.dateTimeFm.stringFromDate(self)
    }
    func timeFM()->String{
        return NSDate.timeFm.stringFromDate(self)
    }
    func timeFM2()->String{
        return NSDate.timeFm2.stringFromDate(self)
    }
    func timeFM3()->String{
        return NSDate.timeFm3.stringFromDate(self)
    }
    func timeFM4()->String{
        return NSDate.timeFm4.stringFromDate(self)
    }
    
    
    
    
    
    
    class func dateFromStr(str:String?)->NSDate?{
        guard let str=str else{
            return nil
        }
        return NSDate.dateFm.dateFromString(str)
    }
    class func dateTimeFromStr(str:String?)->NSDate?{
        guard let str=str else{
            return nil
        }
        return NSDate.dateTimeFm.dateFromString(str)
    }
    class func timeFromStr(str:String?)->NSDate?{
        guard let str=str else{
            return nil
        }
        return NSDate.timeFm.dateFromString(str)
    }
    class func time2FromStr(str:String?)->NSDate?{
        guard let str=str else{
            return nil
        }
        return NSDate.timeFm2.dateFromString(str)
        
    }
    class func time3FromStr(str:String?)->NSDate?{
        guard let str=str else{
            return nil
        }
        return NSDate.timeFm3.dateFromString(str)
        
    }
    class func time4FromStr(str:String?)->NSDate?{
        guard let str=str else{
            return nil
        }
        return NSDate.timeFm4.dateFromString(str)
        
    }
    
    
    class func timestamp() -> String{
        return String(format: "%f", NSDate().timeIntervalSince1970)
        
    }
    
    
}



//blog
extension NSDate{
    func formatBlogTime()->String{
        let secs = -Int(self.timeIntervalSinceNow)
        if secs < 60{
            return "刚刚"
        }else if secs < 60*60{
            return "\(secs/60)分钟前"
       
        }else if NSCalendar.currentCalendar().isDateInYesterday(self) {
            return "昨天 \(self.timeFM3())"
        }else if secs < 24*60*60{
            return "\(secs/60/60)小时前"
        }else if (self.dateFM() as NSString).substringToIndex(4)==(NSDate().dateFM() as NSString).substringToIndex(4){
            return self.dateTimeFM()
        }else{
            return self.timeFM2()
        }
        
    }
}