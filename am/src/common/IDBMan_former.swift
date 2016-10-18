

//
//  SqliteMan.swift
//  day50-sqlite
//
//  Created by apple on 15/12/20.
//  Copyright © 2015年 yf. All rights reserved.
//

import UIKit

class IDBMan_former {
    
    fileprivate let path="test.db"
    fileprivate let sqlfile="tables.sql"
    
    static let ins=IDBMan_former()
    
    var db:OpaquePointer?=nil
    
    
    fileprivate init(){
        openDB(path)
        execSql4F(iRes(sqlfile)!)
    }
    
    func openDB(_ name:String)->Bool{
//         iCommonLog(name.strByAp2Doc())
        if sqlite3_open(name.strByAp2Doc(), &db) != SQLITE_OK{
            iCommonLog("db \(name) fail to open!!")
            return false
        }
        return true
    }
    func execSql(_ sql:String)->Bool{
//        iCommonLog(sql)
        let code = sqlite3_exec(db, sql, nil, nil, nil)
//        iCommonLog(String(UTF8String:sqlite3_errstr(code))!)
        return code == SQLITE_OK
    }
    
    
    
    func execInsert(_ sql:String)->Int64{
        if execSql(sql){
            return sqlite3_last_insert_rowid(db)
        }
        return -1
    }
    

    func execDML(_ sql:String)->Int{
        if execSql(sql){
            return Int(sqlite3_changes(db))
        }
        return -1
    }
    
    func execSql4F(_ path:String)->Bool{
        return execSql(try! String(contentsOfFile: path))
    }
    
    func query(_ sql:String)->[[String:AnyObject]]{
        var stmt:OpaquePointer? = nil
        
        var ary = [[String:AnyObject]]()
        if sqlite3_prepare_v2(db, sql, -1, &stmt, nil) != SQLITE_OK{
            return ary
        }

        for var i=0;sqlite3_step(stmt) == SQLITE_ROW;i+=1 {
           ary.append(rowInfo(stmt!))
        }
        
        sqlite3_finalize(stmt)
        return ary
    }
    
    
    
    func rowInfo(_ stmt:OpaquePointer)->[String:AnyObject]{
        let count = sqlite3_column_count(stmt)
        var dict = [String:AnyObject]()
        for i in 0..<count{

            let name = String(validatingUTF8: sqlite3_column_name(stmt, i))!
            let type = sqlite3_column_type(stmt, i)
           
            var value:AnyObject?=nil
            switch type{
            case SQLITE_INTEGER:
                value =  Int(sqlite3_column_int64(stmt, i)) as AnyObject?
            case SQLITE_FLOAT:
                value =  sqlite3_column_double(stmt, i) as AnyObject?
            case SQLITE3_TEXT:
                value = String(validatingUTF8: UnsafePointer<Int8>(sqlite3_column_text(stmt, i))) as AnyObject?
            case SQLITE_NULL:
                value = nil
            case SQLITE_BLOB:
                break
            default:
                break
            }
            dict[name]=value
            
        }
        return dict
        
    }
    
    
    
    func execTran(_ cb:(()->Bool)){
//        let start = CACurrentMediaTime()
        execSql("begin transaction;")
        if cb(){
            execSql("commit transaction;")
//            iCommonLog("transaction success \(CACurrentMediaTime()-start)")
        }else{
            execSql("rollback transaction;")
//            iCommonLog("transaction fail \(CACurrentMediaTime()-start)")
        }
      
        
    }

}
