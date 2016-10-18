//
//  ContactService.swift
//  am
//
//  Created by apple on 16/5/23.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class ContactService: IDBDao {
    static let ins  = ContactService(table: iConst.CONTACTS)
    
}
