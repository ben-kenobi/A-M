
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
    


 
 
 
    /**
     * method:queryByColName
     *
     * @param colName
     * @return
     */
    
    func  queryByColumn(_ colName:String,colValue:String)->[[String:AnyObject]]{

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
    func  queryDistinctColumnWithId(_ columnName:String)->[[AnyObject]] {
        return ISQLite.ins.queryAry(table!, distinct: true, cols: [columnName,iConst.ID], wher: "1=1 order by \(columnName)", args: [])
  
    }
    
   
    func queryDistinctColumn(_ columnName:String)->[[AnyObject]]{
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
