//
//  Operators.swift
//  day50-sqlite
//
//  Created by apple on 15/12/29.
//  Copyright © 2015年 yf. All rights reserved.
//

import UIKit

//infix operator =~ {
//associativity none
//precedence 130
//}
//infix operator >>> {
//associativity none
//precedence 255
//}

precedencegroup MatchPrece{
    associativity: left
    higherThan: AdditionPrecedence
}

precedencegroup MoveByBitPrece{
    associativity: left
    higherThan: MultiplicationPrecedence
}

infix operator =~ : ComparisonPrecedence
infix operator >>> : BitwiseShiftPrecedence

func =~ (str:String?,re:String)->Bool{
//    print(str,re)
    do{
        guard let s=str else{
            return false
        }
        return try NSRegularExpression(pattern: re, options:.caseInsensitive).firstMatch(in:s, options: [], range: NSMakeRange(0, s.characters.count)) != nil
    }catch _{
        return false
    }
}

func  >>> (val:Int,num:Int)->Int{
    let count = (MemoryLayout<Int>.size)*8
    if num>=count {
        return 0
    }
    return (val >> num) & (1<<(count-num) - 1)
    
}


func ~=(pattern:NSRegularExpression,input:String)->Bool{
    return pattern.firstMatch(in:input, options: [], range: NSMakeRange(0, input.characters.count)) != nil
}
func ~=(pattern:NSRegularExpression,input:AnyObject?)->Bool{
    if let input = input{
        let inps = "\(input)"
        return pattern.firstMatch(in:inps, options: [], range: NSMakeRange(0, inps.characters.count)) != nil
    }else{
        return false
    }
  
}



prefix operator ~/
prefix func ~/(pattern:String) -> NSRegularExpression  {
    return try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
}
