//
//  Date+Ext.swift
//  day-43-microblog
//
//  Created by apple on 15/12/12.
//  Copyright © 2015年 yf. All rights reserved.
//

import Foundation

//basic



extension Date{
    
    
    static func dfm(_ fmstr:String)->DateFormatter{
        let fm=DateFormatter()
        fm.locale=Locale(identifier: "en")
        fm.dateFormat = fmstr
        return fm
    }
    
    @nonobjc static var dateFm:DateFormatter = Date.dfm("yyyy-MM-dd")
    
    @nonobjc static var dateTimeFm:DateFormatter = Date.dfm("MM-dd HH:mm")
    
    @nonobjc static var timeFm:DateFormatter = Date.dfm("yyyy-MM-dd HH:mm:ss")
    
    
    @nonobjc static var timeFm2:DateFormatter = Date.dfm("yyyy-MM-dd HH:mm")
    
    
    @nonobjc static var timeFm3:DateFormatter = Date.dfm("HH:mm")
    
    
    @nonobjc static var timeFm4:DateFormatter = {
        let fm = Date.dfm("EEE MMM dd HH:mm:ss z yyyy")
        fm.locale=Locale(identifier:"en_US")
        return fm
    }()
    

    
    
    
    func dateFM()->String{
        return Date.dateFm.string(from:self)
    }
    func dateTimeFM()->String{
        return Date.dateTimeFm.string(from:self)
    }
    func timeFM()->String{
        return Date.timeFm.string(from:self)
    }
    func timeFM2()->String{
        return Date.timeFm2.string(from:self)
    }
    func timeFM3()->String{
        return Date.timeFm3.string(from:self)
    }
    func timeFM4()->String{
        return Date.timeFm4.string(from:self)
    }
    
    
    
    
    
    
    static func dateFromStr(_ str:String?)->Date?{
        guard let str=str else{
            return nil
        }
        return Date.dateFm.date(from: str)
    }
    static func dateTimeFromStr(_ str:String?)->Date?{
        guard let str=str else{
            return nil
        }
        return Date.dateTimeFm.date(from: str)
    }
    static func timeFromStr(_ str:String?)->Date?{
        guard let str=str else{
            return nil
        }
        return Date.timeFm.date(from: str)
    }
    static func time2FromStr(_ str:String?)->Date?{
        guard let str=str else{
            return nil
        }
        return Date.timeFm2.date(from: str)
        
    }
    static func time3FromStr(_ str:String?)->Date?{
        guard let str=str else{
            return nil
        }
        return Date.timeFm3.date(from: str)
        
    }
    static func time4FromStr(_ str:String?)->Date?{
        guard let str=str else{
            return nil
        }
        return Date.timeFm4.date(from: str)
        
    }
    
    
    static func timestamp() -> String{
        return String(format: "%f", Date().timeIntervalSince1970)
        
    }
    
    
}



//blog
extension Date{
    func formatBlogTime()->String{
        let secs = -Int(self.timeIntervalSinceNow)
        if secs < 60{
            return "刚刚"
        }else if secs < 60*60{
            return "\(secs/60)分钟前"
        }else if NSCalendar.current.isDateInYesterday(self) {
            return "昨天 \(self.timeFM3())"
        }else if secs < 24*60*60{
            return "\(secs/60/60)小时前"
        }else if (self.dateFM() as NSString).substring(to: 4)==(Date().dateFM() as NSString).substring(to: 4){
            return self.dateTimeFM()
        }else{
            return self.timeFM2()
        }
        
    }
}
