//
//  Settings.swift
//  am
//
//  Created by yf on 2018/2/13.
//  Copyright © 2018年 apple. All rights reserved.
//

import Foundation


enum SearchIndexing: Int {
    case Disabled, Enabled
}

struct Setting {
    // 获取settings 中配置的搜索选项值
    static var searchIndexing: SearchIndexing {
        let prefRawValue = iPref()!.integer(forKey:iConst.SearchIndexingPrefKey)
        if let _ = SearchIndexing(rawValue: prefRawValue) {
            return .Enabled
        } else {
            return .Disabled
        }
    }
}
