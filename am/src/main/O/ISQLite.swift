//
//  ISQLite.swift
//  am
//
//  Created by apple on 16/5/11.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class ISQLite: IFMDBMan {
    
    fileprivate static let DB_NAME="idata.db"
    static let  VERSION=3
    static let  TABLE_ACCOUNT="account"
    static let  TABLE_META_DATA="meta_data"
    static let  TABLE_ACCESS="access"
    static let  TABLE_IPATH="IPATH"
    static let  TABLE_CONTACTS="contacts"
    
    
    
    static let ins:ISQLite=ISQLite(name: DB_NAME,version: VERSION)
    
    
    fileprivate override init(name:String,version:Int) {
        super.init(name: name, version: version)
    }
    override func onCreate() {
        _=execSql("create table "+ISQLite.TABLE_ACCOUNT+"(" +
            AccountColumns.ID+" integer primary key autoincrement," +
                AccountColumns.MAILBOX+"  text," +
                AccountColumns.PASSPORT+"  text," +
                AccountColumns.PASSWORD+"  text," +
                AccountColumns.SITENAME+"  text," +
                AccountColumns.USERNAME+"  text," +
                AccountColumns.WEBSITE+"  text," +
                AccountColumns.PHONENUM+"  text," +
                AccountColumns.IDENTIFYING_CODE+"  text," +
                AccountColumns.ASK+"  text," +
                AccountColumns.ANSWER+"  text, " +
                AccountColumns.GROUP+" text default '' " +
            ")");
        
        _=execSql("create table "+ISQLite.TABLE_META_DATA+"(" +
            MetaDataColumns.LANGUAGE+"  text," +
            MetaDataColumns.ACCESSKEY+"  text"
            + ")");
        _=execSql("create table  "+ISQLite.TABLE_ACCESS+"  (" +
            AccessColumns.ID+" integer primary key autoincrement," +
                AccessColumns.NAME+"  text," +
            AccessColumns.ACCESSIBILITY+"   integer" +
            ")");
        _=execSql("create table  "+ISQLite.TABLE_IPATH+"  (" +
            IPathColumns.ID+" integer primary key autoincrement," +
                IPathColumns.NAME+"  text," +
            IPathColumns.PATH+"   text" +
            ")");
        
        _=execSql("create table  "+ISQLite.TABLE_CONTACTS+"  (" +
            ContactColumns.ID+" integer primary key autoincrement," +
                ContactColumns.NAME+"  text," +
            ContactColumns.GROUP+"   text," +
            ContactColumns.PHONE+"   text," +
            ContactColumns.PHONE2+"   text," +
            ContactColumns.TEL+"   text," +
            ContactColumns.CHATACCOUNT+"   text," +
            ContactColumns.EMAIL+"   text," +
            ContactColumns.PS+"   text" +
            ")");
        
        _=rawInsert("insert into  "+ISQLite.TABLE_META_DATA+" values('chinese','')"
        );
        _=rawInsert("insert into  "+ISQLite.TABLE_ACCESS+" values(1,?,1)"
            ,args: [iConst.ACCOUNT]);
        _=rawInsert("insert into  "+ISQLite.TABLE_ACCESS+" values(2,?,1)"
            ,args: [iConst.FILESYSTEM]);
        _=rawInsert("insert into  "+ISQLite.TABLE_ACCESS+" values(3,?,1)"
            ,args: [iConst.CONTACTS]);
        
        _=rawInsert("insert into  "+ISQLite.TABLE_IPATH+"  values(1,?,?)",
                   args: ["root","/"]);
        _=rawInsert("insert into  "+ISQLite.TABLE_IPATH+"  values(2,?,?)",
                   args: ["mnt","/mnt"]);
    }
}


public struct AccountColumns{
    
    static let  ID=iConst.ID,
				
    WEBSITE="website",
    
    SITENAME="sitename",
    
    USERNAME="username",
    
    PASSWORD="password",
    
    PASSPORT="passport",
    
    MAILBOX="mailbox",
    
    PHONENUM="phonenum",
    
    IDENTIFYING_CODE="identifying_code",
    
    ASK="ask",
    
    ANSWER="answer",
    
    GROUP="groupname";
    
    
    
}

public struct MetaDataColumns{
    
    static let LANGUAGE="language",
				
    ACCESSKEY="accesskey";
				
}

public struct AccessColumns{
    
    static  let ID=iConst.ID,
				
				NAME="name",
				
				ACCESSIBILITY="accessibility";
				
}

public struct IPathColumns{
    static let ID=iConst.ID,
				
				NAME="name",
				
				PATH="path";
				
}

public struct ContactColumns{
    static let ID=iConst.ID,
				
				NAME="name",
				
				GROUP="groupname",
				
				PHONE="phone",
				
				PHONE2="phone2",
				
				TEL="tel",
				
				CHATACCOUNT="chataccount",
				
				EMAIL="email",
				
				PS="postscript";
				
}
