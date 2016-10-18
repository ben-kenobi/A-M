//
//  ContactsVC.swift
//  am
//
//  Created by apple on 16/5/17.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class ContactsVC: ItemListVC {

    override func viewDidLoad() {
        platform=iConst.CONTACTS
        super.viewDidLoad()
        view.backgroundColor=iColor(0xff00ff00)
        
    }


}
