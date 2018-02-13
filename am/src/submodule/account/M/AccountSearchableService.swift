//
//  AccountSearchableService.swift
//  am
//
//  Created by yf on 2018/2/13.
//  Copyright © 2018年 apple. All rights reserved.
//

import Foundation
import CoreSpotlight
import MobileCoreServices

public struct AccountSearchableService{
    public init(){}

    
    public func reindexingAccounts(data:[[String:Any]]){
        if #available(iOS 9.0, *) {
            CSSearchableIndex.default().deleteSearchableItems(withDomainIdentifiers: [iConst.ACCOUNT_USER_ACTIVITY_DOMAIN]) { (err) in
                if let error = err{
                    print("Error deleting searching account items: \(error)")
                }else{
                    print("all account indexing deleted.")
                    
                    var searchableAry:[CSSearchableItem] = []
                    for account in data{
                        searchableAry.append(self.searchableItemBy(account: account))
                    }
                    CSSearchableIndex.default().indexSearchableItems(searchableAry) { (err) in
                        if let _ = err{
                            print("indexing fail ")
                        }else{
                            print("indexing success")
                        }
                    }
                    
                }
            }
        } else {
            // Fallback on earlier versions
        }
        
    }
}


extension AccountSearchableService{
    public func accountIden(account:[String: Any])->String{
        return "account_\(String(describing: account[AccountColumns.ID]))"
    }
    public func userActivityUserInfoBy(account:[String: Any])->[String:Any] {
        return ["id" : accountIden(account:account)]
    }
    public func userActivityBy(account:[String: Any]) -> NSUserActivity {
        let activity = NSUserActivity(activityType: iConst.ACCOUNT_USER_ACTIVITY_DOMAIN)
        let name = account[AccountColumns.SITENAME] as! String
        activity.title = name
        activity.userInfo = userActivityUserInfoBy(account:account)
        activity.keywords = [name]
        activity.contentAttributeSet = attributeSetBy(account: account)
        return activity
    }
    
    public func attributeSetBy(account:[String: Any]) -> CSSearchableItemAttributeSet {
        let attributeSet = CSSearchableItemAttributeSet(
            itemContentType: kUTTypeContact as String)
        let name = account[AccountColumns.SITENAME] as! String
        let group = account[AccountColumns.GROUP] as! String

        attributeSet.title = name
        attributeSet.contentDescription = "\(name)  group:\(group)"
//        attributeSet.thumbnailData = UIImageJPEGRepresentation(
//            loadPicture(), 0.9)
        attributeSet.supportsPhoneCall = false
        
        attributeSet.phoneNumbers = [""]
        attributeSet.emailAddresses = [""]
        attributeSet.keywords = [name]
        
        return attributeSet
    }
    
    public func searchableItemBy(account:[String: Any]) -> CSSearchableItem { return CSSearchableItem(uniqueIdentifier: accountIden(account: account), domainIdentifier: iConst.ACCOUNT_USER_ACTIVITY_DOMAIN, attributeSet: attributeSetBy(account: account))
    }
}
