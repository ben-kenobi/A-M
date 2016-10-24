//
//  FMDBMan.swift
//  day50-sqlite
//
//  Created by apple on 15/12/21.
//  Copyright © 2015年 yf. All rights reserved.
//

import UIKit

class IFMDBMan_former {
    
    private let path="fmtest.db"
    private let sqlfile="tables.sql"
    
    static let ins:IFMDBMan_former=IFMDBMan_former()
    
    let queue:FMDatabaseQueue
    
    private init(){
        queue=FMDatabaseQueue(path: path.strByAp2Doc())
        if !execSql4F(iRes(sqlfile)!){
            iCommonLog(" fail to init fmdb")
        }
    }
    
    
    func execSql4F(_ path:String)->Bool{
        return execSql(try! String(contentsOfFile: path))
    }
    func execSql(_ sql:String)->Bool{
        var b:Bool = false
        queue.inDatabase { (db) -> Void in
            
            b = db?.executeStatements(sql) ?? false
        }
        return b
    }
    
    
    
    
    
    
    func insert(_ sql:String,args:[Any]?=nil,dict:[String:Any]?=nil)->Int64{
        var b:Bool=false
        var id:Int64 = 0
        queue.inDatabase { (db) -> Void in
            if args != nil{
                b=db?.executeUpdate(sql, withArgumentsIn: args) ?? false
            }else if dict != nil{
                b=db?.executeUpdate(sql, withParameterDictionary: dict) ?? false
            }else{
                b=db?.executeUpdate(sql) ?? false
            }
            
            id = db?.lastInsertRowId() ?? -1
            
        }
        return b ? id: -1
    }
    
    
    
    
    
    
    func update(_ sql:String,args:[Any]?=nil,dict:[String:Any]?=nil)->Int{
        var b:Bool=false
        var count:Int = 0
        queue.inDatabase { (db) -> Void in
            if args != nil{
                b=db?.executeUpdate(sql, withArgumentsIn: args) ?? false
            }else if dict != nil{
                b=db?.executeUpdate(sql, withParameterDictionary: dict) ?? false
            }else{
                b=db?.executeUpdate(sql) ?? false
            }
            
            count = Int(db?.changes() ?? 0)
        }
        return b ? count : -1
    }
    
    
    func query(_ sql:String,args:[Any]?=nil,dict:[String:Any]?=nil)->[[String:Any]]{
        var ary = [[String:Any]]()
        queue.inDatabase { (db) -> Void in
            var rs:FMResultSet?
            if args != nil{
                rs=db?.executeQuery(sql, withArgumentsIn: args)
            }else if dict != nil {
                rs=db?.executeQuery(sql, withParameterDictionary: dict)
            }else{
                rs=db?.executeQuery(sql)
            }
            
            
            if let rs = rs{
                while rs.next(){
                    ary.append(self.rowInfo(rs))
                }
            }
        }
        return ary
    }
    
    
    
    func rowInfo(_ rs:FMResultSet)->[String:Any]{
        var row = [String:Any]()
        
        let count = rs.columnCount()
        for i in 0..<count{
            row[rs.columnName(for: i)]=rs.object(forColumnIndex: i)
        }
        return row
    }
    
    
    
 
    
}


