//
//  IFileComparator.swift
//  am
//
//  Created by apple on 16/10/27.
//  Copyright © 2016年 apple. All rights reserved.
//

import Foundation
class IFileComparator{
    var type:Int = 0
    
    
    @discardableResult func setType(_ type:Int)->Bool{
        if self.type == type {
            return false
        }
        self.type = type
        return true
    }
    
    func compareByType(_ left:String,_ right:String) ->Int {
        
        switch (type) {
        case 0:
            return (left as NSString).lastPathComponent.lowercased().compare((right as NSString).lastPathComponent.lowercased()) == .orderedAscending ? -1 : 1
            
        case 1:
            return (left as NSString).lastPathComponent.lowercased().compare((right as NSString).lastPathComponent.lowercased()) == .orderedDescending ? -1 : 1
       
            
        case 2:
            
            
            if FileUtil.isDir(left){
                return (left as NSString).lastPathComponent.lowercased().compare((right as NSString).lastPathComponent.lowercased()) == .orderedAscending ? -1 : 1
            }else{
                let leftdict = try? iFm.attributesOfItem(atPath: left)
                let rightdict = try? iFm.attributesOfItem(atPath: right)
                if let leftdict = leftdict ,let rightdict = rightdict{
                    return (leftdict[FileAttributeKey.size] as! NSNumber).compare((rightdict[FileAttributeKey.size] as! NSNumber)) == .orderedAscending ? -1 : 1
                }
                return -1
            }
            
            
        case 3:
            
            if FileUtil.isDir(left){
                return (left as NSString).lastPathComponent.lowercased().compare((right as NSString).lastPathComponent.lowercased()) == .orderedAscending ? -1 : 1
            }else{
                let leftdict = try? iFm.attributesOfItem(atPath: left)
                let rightdict = try? iFm.attributesOfItem(atPath: right)
                if let leftdict = leftdict ,let rightdict = rightdict{
                    return (leftdict[FileAttributeKey.size] as! NSNumber).compare((rightdict[FileAttributeKey.size] as! NSNumber)) == .orderedDescending ? -1 : 1
                }
                
                return -1
          
            }
            
        case 4:
            let leftdict = try? iFm.attributesOfItem(atPath: left)
            let rightdict = try? iFm.attributesOfItem(atPath: right)
            if let leftdict = leftdict ,let rightdict = rightdict{
                return (leftdict[FileAttributeKey.modificationDate] as! Date).compare((rightdict[FileAttributeKey.modificationDate] as! Date)) == .orderedAscending ? -1 : 1
            }
            return -1
        case 5:
            let leftdict = try? iFm.attributesOfItem(atPath: left)
            let rightdict = try? iFm.attributesOfItem(atPath: right)
            if let leftdict = leftdict ,let rightdict = rightdict{
                return (leftdict[FileAttributeKey.modificationDate] as! Date).compare((rightdict[FileAttributeKey.modificationDate] as! Date)) == .orderedDescending ? -1 : 1
            }
            return -1
        default:return -1
        }
    }
    
    
    func  compareFile(_ left:String,_ right:String)->Int{
        let delta = FileUtil.compareFileType(left, right);
        if (delta != 0){
            return delta
        }
        return compareByType(left, right);
        
    }
    
    func compare(_ left:String,_ right:String) ->Int{
        return compareFile(left, right);
    }
}

