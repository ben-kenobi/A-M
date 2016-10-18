//
//  Operators.swift
//  day50-sqlite
//
//  Created by apple on 15/12/29.
//  Copyright © 2015年 yf. All rights reserved.
//

import UIKit

infix operator =~ {
associativity none
precedence 130
}
infix operator >>> {
associativity none
precedence 255
}

func =~ (str:String?,re:String)->Bool{
//    print(str,re)
    do{
        guard let s=str else{
            return false
        }
        return try NSRegularExpression(pattern: re, options:.CaseInsensitive).firstMatchInString(s, options: [], range: NSMakeRange(0, s.characters.count)) != nil
    }catch _{
        return false
    }
}

func  >>> (val:Int,num:Int)->Int{
    let count = sizeof(Int)*8
    if num>=count {
        return 0
    }
    return (val >> num) & (1<<(count-num) - 1)
    
}


func ~=(pattern:NSRegularExpression,input:String)->Bool{
    return pattern.firstMatchInString(input, options: [], range: NSMakeRange(0, input.characters.count)) != nil
}
func ~=(pattern:NSRegularExpression,input:AnyObject?)->Bool{
    if let input = input{
        let inps = "\(input)"
          return pattern.firstMatchInString(inps, options: [], range: NSMakeRange(0, inps.characters.count)) != nil
    }else{
        return false
    }
  
}



prefix operator ~/{}
prefix func ~/(pattern:String) -> NSRegularExpression  {
    return try! NSRegularExpression(pattern: pattern, options: .CaseInsensitive)
}
