//
//  IFileFilter.swift
//  am
//
//  Created by apple on 16/10/27.
//  Copyright © 2016年 apple. All rights reserved.
//

import Foundation

class IFileFilter {
    var  type:Int = 0;
    
     @discardableResult func  setType(_ type:Int) ->Bool{
        if (self.type == type){
            return false
        }
        self.type = type
        return true;
    }
    
    func accept(_ file:String)->Bool {
        var b = true
        switch (type) {
        case 0:
            b = true;
            break;
        case 1:
            b = FileUtil.isFile(file)
            break;
        case 2:
            b = FileUtil.isDir(file)
            break;
        case 3:
            b = FileUtil.isInvalid(file)
            break;
        case 4:
            b = iFm.isWritableFile(atPath: file)
            break;
        case 5:
            b = iFm.isReadableFile(atPath: file)
            break;
        default: break
            
        }
        return b;
    }
}
