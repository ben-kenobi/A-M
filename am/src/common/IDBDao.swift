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
    
     func add(dict:[String:String])->Int64{
        return  ISQLite.ins.insert(table!, dict: dict)
        
    }
    func insert(dict:[String:AnyObject])->Int64{
        return  ISQLite.ins.insert(table!, dict: dict)
        
    }
    func delete(wher:String,args:[AnyObject])->Int{
        return ISQLite.ins.delete(table!, wher: wher, args: args)
    }
    
     func update(dict:[String:AnyObject],wher:String?,args:[AnyObject])->Int{
        return ISQLite.ins.update(table!, dict: dict, wher: wher, args: args)
        
    }
    func updateById(dict:[String:AnyObject],id:Int)->Int{
        return update(dict, wher: "\(ID)=?", args: [id])
    }
    
    
  
    func query(distinct:Bool,cols:[String],wher:String,args:[AnyObject])->[[String:AnyObject]]{
        return ISQLite.ins.query(table!, distinct: distinct, cols: cols, wher: wher, args: args)
    }
    func queryAry(distinct:Bool,cols:[String],wher:String,args:[AnyObject])->[[AnyObject]]{
        return ISQLite.ins.queryAry(table!, distinct: distinct, cols: cols, wher: wher, args: args)
    }
    
    
    func batchAdd(dicts:[[String:String]])->(Int,Int) {
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
    
    func batchInsert(dicts:[[String:AnyObject]])->(Int,Int){
        var result:(Int,Int) = (0,0)
        ISQLite.ins.transaction { (db, rollback) in
            for dict in dicts{
                if ISQLite.ins.insert(self.table!, dict: dict,db: db) > 0{
                    result.0 += 1
                }else{
                    result.1 += 1
                }
            }
        }
        return result
    }
    
    func addOrUpdate(dict:[String:String])->Bool{
        if let id = dict[ID]{
            return update(dict, wher: "\(ID)=?", args: [id]) > 0
        }else{
            return add(dict) > 0
        }
    }
    func insertOrUpdate(dict:[String:AnyObject])->Bool{
        if let id = dict[ID]{
            return update(dict, wher: "\(ID)=?", args: [id]) > 0
        }else{
            return insert(dict) > 0
        }
    }
    
    
    
    
    
    func query(id:String)->[[String:AnyObject]]{
        return query(false, cols: [], wher: "\(ID)=?", args: [id])
    }
    
    
    func delete(id:String)->Bool{
        return delete("\(ID)=?", args: [id]) == 1
    }
    func delete (ids:NSSet)->Int{
        var idstr = ""
        for (i,id) in ids.enumerate(){
            if i>0{
                idstr += ","
            }
            idstr += "'\(id)'"
        }
        
        return delete("\(ID) in (\(idstr))", args: [])
    }
    
}


