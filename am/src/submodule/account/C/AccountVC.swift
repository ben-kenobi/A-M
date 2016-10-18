//
//  AccountVC.swift
//  am
//
//  Created by apple on 16/5/17.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit



class AccountVC: ItemListVC {
    var colName:String = ""
    var colVal:String = "*"
    
    let iconlist = [iimg("categories"),iimg("aticon"),iimg("mailbox"),
                    iimg("phonenum"),iimg("passport")]
    let colnamelist = [AccountColumns.GROUP,AccountColumns.SITENAME,
                       AccountColumns.MAILBOX,AccountColumns.PHONENUM,
                       AccountColumns.PASSPORT]
    var gridPop:GridPop?

    
   
}
extension AccountVC{
    override func viewDidLoad() {
        platform=iConst.ACCOUNT
        super.viewDidLoad()
        contentTV.register(AccountItemCell.self, forCellReuseIdentifier: CommonListItemCell.celliden)
        
        
        
    }
    override func updateData(){
        datas=AccountService.ins.queryByColumn(colName, colValue: colVal)
        contentTV.reloadData()
    }
    
    override func showSearchDailog(){
        if gridPop == nil{
            gridPop = GridPop.gridPopWith(iStrary["pickerOptions"]!, title: "分类查看(全部)", cb: { (pos, dialog) in
                dialog.updateUI(AccountService.ins.queryDistinctColumn2(self.colnamelist[pos]), icon: self.iconlist[pos])
               self.colName = self.colnamelist[pos]
            }) { (pos, dialog) in
                if pos == -1{
                    self.colVal="*"
                }else{
                    self.colVal = dialog.datas![pos]
                }
                self.updateData()
                dialog.dismiss()
            }
        }
        gridPop!.show()
    }
    
}



