//
//  IDBDao.swift
//  am
//
//  Created by apple on 16/5/22.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class IDBDao {
     var table:String?
    let ID = iConst.ID
    
    init(table:String){
        self.table=table
        
    }
    
     func add(_ dict:[String:String])->Int64{
        return  ISQLite.ins.insert(table!, dict: dict)
        
    }
    func delete(_ wher:String,args:[AnyObject])->Int{
        return ISQLite.ins.delete(table!, wher: wher, args: args)
    }
    
     func update(_ dict:[String:AnyObject],wher:String?,args:[AnyObject])->Int{
        return ISQLite.ins.update(table!, dict: dict, wher: wher, args: args)
        
    }
    
    
  
    func query(_ distinct:Bool,cols:[String],wher:String,args:[AnyObject])->[[String:AnyObject]]{
        return ISQLite.ins.query(table!, distinct: distinct, cols: cols, wher: wher, args: args)
    }
    func queryAry(_ distinct:Bool,cols:[String],wher:String,args:[AnyObject])->[[AnyObject]]{
        return ISQLite.ins.queryAry(table!, distinct: distinct, cols: cols, wher: wher, args: args)
    }
    
    
    func batchAdd(_ dicts:[[String:String]])->(Int,Int) {
        var result:(Int,Int) = (0,0)
        for dict in dicts{
            if add(dict) > 0{
                result.0 += 1
            }else{
                result.1 += 1
            }
        }
        return result
    }
    
    func addOrUpdate(_ dict:[String:String])->Bool{
        if let id = dict[ID]{
            return update(dict as [String : AnyObject], wher: "\(ID)=?", args: [id as AnyObject]) > 0
        }else{
            return add(dict) > 0
        }
    }
    
    
    
    
    
    func query(_ id:String)->[[String:AnyObject]]{
        return query(false, cols: [], wher: "\(ID)=?", args: [id as AnyObject])
    }
    
    
    func delete(_ id:String)->Bool{
        return delete("\(ID)=?", args: [id as AnyObject]) == 1
    }
    func delete (_ ids:NSSet)->Int{
        var idstr = ""
        for (i,id) in ids.enumerated(){
            if i>0{
                idstr += ","
            }
            idstr += "'\(id)'"
        }
        
        return delete("\(ID) in (\(idstr))", args: [])
    }
    
}


