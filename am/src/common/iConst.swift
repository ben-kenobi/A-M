


//
//  iConst.swift
//  day-43-microblog
//
//  Created by apple on 15/12/17.
//  Copyright © 2015年 yf. All rights reserved.
//

import UIKit

class iConst{
    static let deciRE:NSRegularExpression = try!NSRegularExpression.init(pattern: "^[1-9][0-9]{0,}\\.{0,1}[0-9]{0,}$", options: [])

   static  let EmoClickNoti="emoclickednoti"
    static  let EmoDelClickNoti="emoDelclickednoti"
    static let defServerIp="3dspace.xicp.net:20080"
    static let defHttpPref="http://"
    
    static let ID="_id"
    
    
    static let  PLATFORM_ENCODING="UTF-8"
    
    static let  DEBUG = false
    static let  SMALLFILEPREFIX="___";
    
    static let  TIME_PATTERN="yyyy-MM-dd  HH:mm:ss";
    static  var  TIMESDF:DateFormatter = {
        let df =  DateFormatter()
        df.dateFormat=TIME_PATTERN
        return df
    }()
    static let  TIMESDF2:DateFormatter = {
        let df =  DateFormatter()
        df.dateFormat="yyyyMMddHHmmss"
        return df
    }()
    static let  DATE_PATTERN="yyyy-MM-dd";
    static let  DATESDF:DateFormatter = {
        let df =  DateFormatter()
        df.dateFormat=DATE_PATTERN
        return df
    }()
    
    static let  PNG_DATE_PATTERN="'PNG'_yyyyMMdd_HHmmss'.png'"
    static let  PNGDATESDF:DateFormatter = {
        let df =  DateFormatter()
        df.dateFormat=PNG_DATE_PATTERN
        return df
    }()
    
    static let  MP4_DATE_PATTERN="'MP4'_yyyyMMdd_HHmmss'.mp4'"
    static let  MP4DATESDF:DateFormatter = {
        let df =  DateFormatter()
        df.dateFormat=MP4_DATE_PATTERN
        return df
    }()
    
    

    
    
    
    
    
    static let NAME="name";
    static let ACCOUNT="account";
    static let CONTACTS="contacts";
    static let FILESYSTEM="filesystem";
    static let MATCH_ALL="*";
    static let BACKUPDIR_SUF="backup";
    static let BACKUPFILE_SUF="_backup";
    
    static let FILE_ALREADY_EXISTS="文件已存在";
    static let MKDIR_SUCCESS="创建成功";
    static let MKDIR_FAIL="创建失败";
    static let DELETE_FAIL="文件或文件夹无法删除";
    static let DELETE_SUCCESS="完成删除";
    static let RENAME_SUCCESS="重命名完成";
    static let UNCHANGED="未改变";
    static let RENAME_FAIL="未能执行该次重命名";
    static let RENAME_CONFLICT="未能执行该操作,文件名冲突";
    static let LOCAL_SERVICE="7378423";
    
    static let FILE="file";
    static let DIRECTORY="directory";
    
    static let FILE_COPY_LIST="fileCopyList";
    static let FILE_MOVE_LIST="fileMoveList";
    static let FILE_PARENT="fileParent";
    static let FILE_PASTE_TYPE="filePasteType";    
    static let  minGestureInterval=250;
    
    static let orgTitCol=iColor(0xffee7600)
    static let blueBg=iColor(0xff00bfee)
    static let khakiBg=iColor(255,246,231)
    static let iGlobalBG = iColor(230,230,230)
    static let iGlobalGreen = iColor(33,197,180)
    
    static let iGlobalBlue = iColor(63,169,248)
    static let TextBlue = iColor(0,122,255)
    static let TextRed = iColor(193,40,117)
    static let TextGreen = iColor(63,130,139)
    
    static let ACCOUNT_USER_ACTIVITY_DOMAIN="com.yf.am.account"

    static let SearchIndexingPrefKey="SearchIndexingPrefKey"


}

