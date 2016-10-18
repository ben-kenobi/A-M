//
//  StaticMod.swift
//  am
//
//  Created by apple on 16/5/19.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class StaticMod {
    static let ACC_DATAS:[[String:String]] = [
        ["key":AccountColumns.SITENAME,"title":"站点名称","val":""],
        ["key":AccountColumns.MAILBOX,"title":"邮箱","val":""],
        ["key":AccountColumns.USERNAME,"title":"用户名","val":""],
        ["key":AccountColumns.PASSWORD,"title":"密码","val":""],
        ["key":AccountColumns.GROUP,"title":"分组","val":""],
        ["key":AccountColumns.PASSPORT,"title":"通行证","val":""],
        ["key":AccountColumns.PHONENUM,"title":"电话号码","val":""],
        ["key":AccountColumns.WEBSITE,"title":"站点地址","val":""],
        ["key":AccountColumns.IDENTIFYING_CODE,"title":"验证码","val":""],
        ["key":AccountColumns.ASK,"title":"提问","val":""],
        ["key":AccountColumns.ANSWER,"title":"回答","val":""]
    ]
    static var ACC_MUTABLE_DATAS:[NSMutableDictionary] {
        get{
           var ary = [NSMutableDictionary]()
            for dict in ACC_DATAS{
                ary.append(NSMutableDictionary(dictionary: dict))
            }
            return ary
        }
    }

}
