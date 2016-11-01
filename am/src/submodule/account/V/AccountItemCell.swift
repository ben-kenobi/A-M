//
//  AccountItemCell.swift
//  am
//
//  Created by apple on 16/5/24.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class AccountItemCell: CommonListItemCell {
    let siteAtt  = [NSForegroundColorAttributeName:iColor(38,146,42),NSFontAttributeName:ibFont(19)]
    let titleAtt  = [NSForegroundColorAttributeName:iConst.orgTitCol,NSFontAttributeName:ibFont(18)]
    let otherAtt  = [NSForegroundColorAttributeName:iColor(0xff444444),NSFontAttributeName:ibFont(17)]
    let showCols:[String] = [AccountColumns.SITENAME,
                             AccountColumns.MAILBOX,
        AccountColumns.USERNAME,
        AccountColumns.PASSWORD,
        AccountColumns.GROUP,
        AccountColumns.PASSPORT,
        AccountColumns.PHONENUM
    ]
    let localColNameMap:[String:String]=[AccountColumns.SITENAME:"名称",AccountColumns.MAILBOX:"邮箱",AccountColumns.USERNAME:"用户名",AccountColumns.PASSWORD:"密码",AccountColumns.GROUP:"组别",AccountColumns.PASSPORT:"通行证",AccountColumns.PHONENUM:"电话"]
  
    var showContent:NSMutableAttributedString?{
        get{
            if let mod = mod{
                let show = NSMutableAttributedString(string:localColNameMap[showCols[0]]! + ": ")
                 show.addAttributes(titleAtt, range: NSMakeRange(0, show.length))
                var sub = NSAttributedString(string: "\(mod[showCols[0]]!)\n",attributes:siteAtt)
                
                show.append(sub)
                for (i,colname) in showCols.enumerated(){
                    if i != 0{
                        let val = "\(mod[colname]!)"
                        if !isBlank(val){
                             sub = NSAttributedString(string: localColNameMap[colname]! + ": ",attributes:titleAtt)
                            show.append(sub)

                            sub = NSAttributedString(string: "\(mod[colname]!)\n",attributes:otherAtt)
                            show.append(sub)

                        }
                    }
                }
                
                
               
                 show.deleteCharacters(in: NSMakeRange(show.length-1, 1))
                return show
                
            }
            return nil
        }
    }
    
    
}

extension AccountItemCell{
    
    override func updateUI(){
        textLab.attributedText=showContent
        
    }
    
        
}

