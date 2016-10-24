//
//  IFMDBMan.swift
//  am
//
//  Created by apple on 16/5/11.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class IFMDBMan {
    let queue:FMDatabaseQueue
    
    init(name:String,version:Int) {
        queue=FMDatabaseQueue(path: name.strByAp2Doc())
        
        
        _=execSql("CREATE TABLE  if not exists t_metadata (version INTEGER NOT NULL);")
        var res:[[String:Any]]=rawQuery("SELECT version FROM t_metadata;")
        if res.count == 0{
            _=rawInsert("INSERT INTO t_metadata VALUES(\(version));")
            onCreate()
        }else{
            if let oldversion = res[0]["version"] as?Int , oldversion != version{
                _=rawUpdate("UPDATE  t_metadata SET version=\(version);")
                onUpdate()
            }else{}
            
        }
    }
    
    func onCreate(){
        print("oncreate")
    }
    func onUpdate(){
        print("onupdate")

    }
    
    
    
    
    
    
    
    func execSql4F(_ path:String)->Bool{
        return execSql(try! String(contentsOfFile: path))
    }
    func execSql(_ sql:String,db:FMDatabase? = nil)->Bool{
        var b:Bool = false
        if let db = db{
            b = db.executeStatements(sql)
        }else{
            queue.inDatabase { (db) -> Void in
               b=self.execSql(sql,db: db)
            }
        }
        return b

    }
    
    
    
    
    
    
    func rawInsert(_ sql:String,args:[Any]?=nil,dict:[String:Any]?=nil,db:FMDatabase? = nil)->Int64{
        var id:Int64 = 0
        if let db = db{
            var b:Bool=false
            if args != nil{
                b=db.executeUpdate(sql, withArgumentsIn: args)
            }else if dict != nil{
                b=db.executeUpdate(sql, withParameterDictionary: dict)
            }else{
                b=db.executeUpdate(sql)
            }
            
            id = b ? db.lastInsertRowId() : -1

        }else{
        queue.inDatabase { (db) -> Void in
            id=self.rawInsert(sql,args: args,dict: dict,db: db)
        }
        }
        return id
    }
    
   
    
    
    
    func rawUpdate(_ sql:String,args:[Any]?=nil,dict:[String:Any]?=nil,db:FMDatabase? = nil)->Int{
        var count:Int = 0
        if let db = db{
            var b:Bool=false
            if args != nil{
                b=db.executeUpdate(sql, withArgumentsIn: args)
            }else if dict != nil{
                b=db.executeUpdate(sql, withParameterDictionary: dict)
            }else{
                b=db.executeUpdate(sql)
            }
            count = b ? Int(db.changes()) : -1
        }else{
            queue.inDatabase { (db) -> Void in
                count = self.rawUpdate(sql,args: args,dict: dict,db:db)
            }
        }
        
        return count
    }
    
    
    func rawQuery(_ sql:String,args:[Any]?=nil,dict:[String:Any]?=nil,db:FMDatabase? = nil)->[[String:Any]]{
        var ary = [[String:Any]]()
        if let db = db {
            var rs:FMResultSet?
            if args != nil{
                rs=db.executeQuery(sql, withArgumentsIn: args)
            }else if dict != nil {
                rs=db.executeQuery(sql, withParameterDictionary: dict)
            }else{
                rs=db.executeQuery(sql)
            }
            
            
            if let rs = rs{
                while rs.next(){
                    ary.append(self.rowInfo(rs))
                }
            }

        }else{
            queue.inDatabase { (db) -> Void in
                ary = self.rawQuery(sql,args: args,dict: dict,db: db)
            }
        }
        
        return ary
    }
    
    func rawQueryAry(_ sql:String,args:[Any]?=nil,dict:[String:Any]?=nil,db:FMDatabase? = nil)->[[Any]]{
        var ary = [[Any]]()
        if let db = db {
            var rs:FMResultSet?
            if args != nil{
                rs=db.executeQuery(sql, withArgumentsIn: args)
            }else if dict != nil {
                rs=db.executeQuery(sql, withParameterDictionary: dict)
            }else{
                rs=db.executeQuery(sql)
            }
            
            
            if let rs = rs{
                while rs.next(){
                    ary.append(self.rowAryInfo(rs))
                }
            }
        }else {
            queue.inDatabase { (db) -> Void in
                ary = self.rawQueryAry(sql,args: args,dict: dict,db: db)
            }
        }
        
        return ary
    }
    
    
    
    
    
    func rowInfo(_ rs:FMResultSet)->[String:Any]{
        var row = [String:Any]()
        
        let count = rs.columnCount()
        for i in 0..<count{
            row[rs.columnName(for:i)]=rs.object(forColumnIndex: i)
        }
        return row
    }
    func rowAryInfo(_ rs:FMResultSet)->[Any]{
        var row = [Any]()
        
        let count = rs.columnCount()
        for i in 0..<count{
            row.append(rs.object(forColumnIndex: i))
        }
        return row
    }
    
    
    func transaction(_ cb: @escaping (_ db:FMDatabase?,_ rollback:UnsafeMutablePointer<ObjCBool>?)->()){
  
        queue.inTransaction(cb)
    }
    
    
    
}












extension  IFMDBMan{
    
    func insert(_ table:String, dict:[String:Any],db:FMDatabase?=nil)->Int64{
        var mdict = dict
        mdict.removeValue(forKey: iConst.ID)
       
        var colums = ""
        var placeholders = ""
        
        for k:String in mdict.keys {
            colums += "\(k),"
            placeholders += ":\(k),"
        }
        placeholders = (placeholders as NSString ).substring(to: placeholders.len-1)
        colums = (colums as NSString ).substring(to: colums.len-1)
        
        let sql  = "insert into \(table)(\(colums)) values (\(placeholders)); "
        
        //        print(sql+"-------------------\n")
        
        return rawInsert(sql,  dict: mdict, db: db)
    }
    
    func update(_ table:String,dict:[String:Any],wher:String?,args:[Any],db:FMDatabase?=nil)->Int{
        var mdict = dict
        mdict.removeValue(forKey: iConst.ID)

        var sql  = "update \(table) set "
        
        for k in mdict.keys {
            
            sql += "\(k)=:\(k),"
            
        }
        sql = (sql as NSString).substring(to: sql.len-1)
        var condi = ""
        
        if let wher = wher {
            var nswher = wher as NSString
            var ran =  nswher.range(of: "?")
            var idx = 0
            while ran.location != NSNotFound{
                nswher = nswher.replacingCharacters(in: ran, with: "'\(args[idx])'") as NSString
                ran = nswher.range(of: "?")
                idx += 1
            }
            condi = nswher as String
            
        }
        if !isBlank(condi){
            sql += "  where \(condi) "
        }
        sql += ";"
        
//        print(sql+"-------------------\n")
        return rawUpdate(sql, dict: mdict, db: db)
    }
    
    func delete(_ table:String,wher:String,args:[Any],db:FMDatabase?=nil)->Int{
        
        let sql  = "delete from  \(table) where \(wher) ;"
        
        //        print(sql+"-------------------\n")
        return rawUpdate(sql, args: args, db: db)
        
    }
   
    func query(_ table:String,distinct:Bool,cols:[String],wher:String,args:[Any],db:FMDatabase?=nil)->[[String:Any]]{
        var colstr = ""
        for (i,s) in cols.enumerated(){
            if i>0 {
                colstr += ","
            }
            colstr += "\(s)"
        }
        if colstr==""{
            colstr="*"
        }
        let sql  = "select \(distinct ? "distinct" : "") \(colstr) from \(table) where \(wher);"
//        print(sql+"------------------\n")
        return rawQuery(sql,args: args,db:db)
    }
    func queryAry(_ table:String,distinct:Bool,cols:[String],wher:String,args:[Any],db:FMDatabase?=nil)->[[Any]]{
        var colstr = ""
        for (i,s) in cols.enumerated(){
            if i>0 {
                colstr += ","
            }
            colstr += "\(s)"
        }
        if colstr==""{
            colstr="*"
        }
        let sql  = "select \(distinct ? "distinct" : "") \(colstr) from \(table) where \(wher);"
        return rawQueryAry(sql,args: args,db:db)
    }
    
    
}
