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
        for  sec in 0..<(self.dataSource?.numberOfSectionsInTableView?(self) ?? 0){
            for  row in 0..<(self.dataSource?.tableView(self, numberOfRowsInSection: sec) ?? 0){
                self.selectRowAtIndexPath(NSIndexPath.init(forRow: row, inSection: sec), animated: false, scrollPosition: UITableViewScrollPosition.None)
            }
            
        }
  
    }
    
}
