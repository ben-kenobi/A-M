//
//  TableView+Ext.swift
//  am
//
//  Created by apple on 16/5/27.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

extension UITableView  {
    func selectAll(){
        for  sec in 0..<(self.dataSource?.numberOfSections?(in: self) ?? 0){
            for  row in 0..<(self.dataSource?.tableView(self, numberOfRowsInSection: sec) ?? 0){
                self.selectRow(at: IndexPath.init(row: row, section: sec), animated: false, scrollPosition: UITableViewScrollPosition.none)
            }
            
        }
  
    }
    
}
