
//
//  AccountService.swift
//  am
//
//  Created by apple on 16/5/21.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class AccountService :IDBDao {
    static  let ins:AccountService = AccountService(table: iConst.ACCOUNT)
    

    // override
    
    override func add(_ dict:[String:String])->Int64{
        let ret = super.add(dict)
        self.reindexing()
        return ret
    }
    override func insert(_ dict:[String:Any])->Int64{
        let ret = super.insert(dict)
        self.reindexing()
        return ret
    }
    override func delete(_ wher:String,args:[Any])->Int{
        let ret = super.delete(wher, args: args)
        self.reindexing()
        return ret
    }
    
    override func update(_ dict:[String:Any],wher:String?,args:[Any])->Int{
        let ret = super.update(dict, wher: wher, args: args)
        self.reindexing()
        return ret
    }
    override func updateById(_ dict:[String:Any],id:Int)->Int{
        let ret = super.updateById(dict, id: id)
        self.reindexing()
        return ret
    }
    
    override func batchAdd(_ dicts:[[String:String]])->(Int,Int) {
        let ret = super.batchAdd(dicts)
        self.reindexing()
        return ret
    }
    
    override func batchInsert(_ dicts:[[String:Any]])->(Int,Int){
        let ret = super.batchInsert(dicts)
        self.reindexing()
        return ret
    }
    
    override func addOrUpdate(_ dict:[String:String])->Bool{
        let ret = super.addOrUpdate(dict)
        self.reindexing()
        return ret
    }
    override func insertOrUpdate(_ dict:[String:Any])->Bool{
        let ret = super.insertOrUpdate(dict)
        self.reindexing()
        return ret
    }
    
    override func delete(_ id:String)->Bool{
        let b = super.delete(id)
        self.reindexing()
        return b
    }
   override func delete (_ ids:Set<String>)->Int{
        let ret = super.delete(ids)
        self.reindexing()
        return ret
    }
 
    func reindexing(){
        AccountSearchableService.indexingAllAccount()
    }
 
 
    /**
     * method:queryByColName
     *
     * @param colName
     * @return
     */
    
    func  queryByColumn(_ colName:String,colValue:String)->[[String:Any]]{

    if (iConst.MATCH_ALL == colValue) {
        return ISQLite.ins.query(table!, distinct: false, cols: ["*"], wher: "1=1 order by \(AccountColumns.SITENAME)", args: [])
        } else {
        return ISQLite.ins.query(table!, distinct: false, cols: ["*"], wher: "\(colName)=? order by \(AccountColumns.SITENAME)", args: [colValue])
    }
    
    }

    
    
    /**
     * method: queryDistinctColumn
     *
     * @param columnName
     * @return
     */
    func  queryDistinctColumnWithId(_ columnName:String)->[[Any]] {
        return ISQLite.ins.queryAry(table!, distinct: true, cols: [columnName,iConst.ID], wher: "1=1 order by \(columnName)", args: [])
  
    }
    
   
    func queryDistinctColumn(_ columnName:String)->[[Any]]{
        return ISQLite.ins.queryAry(table!, distinct: true, cols: [columnName], wher: "1=1 order by \(columnName)", args: [])
    }
    func queryDistinctColumn2(_ columnName:String)->[String]{
        var strary = [String]()
        for ary in  ISQLite.ins.queryAry(table!, distinct: true, cols: [columnName], wher: "1=1 order by \(columnName)", args: []){
            let str = ary[0] as! String
            strary.append(str)
        }
        return strary
    }
    
}
