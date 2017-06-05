//
//  String+.swift
//  Quak
//
//  Created by 高炼 on 16/10/19.
//  Copyright © 2016年 mangonob. All rights reserved.
//

import Foundation
import UIKit

private let NoneLock: [String] = [
    "App Store",
    "iBooks",
    "iTunes Store",
    "Mail",
    "Map",
    "Message",
    "News",
    "Podcast",
    "Reminders",
    "Safari",
    "Videos",
    "Wallet",
    "Dropbox",
    "Chrome",
    "AliPay",
    "PayPal",
    "Uber",
]

private let FirstLock: [String] = [
    "Photos", "Music", "Weather", "QQ", "Facebook", "Instagram"
]
extension String {
    var validAsURL: Bool {
        guard let url = validURL else { return false }
        return UIApplication.sharedApplication().canOpenURL(url)
    }
    
    func validURL(query: String) -> NSURL? {
        guard let query = query.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) else { return nil }
        guard let pattern = try? NSRegularExpression(pattern: "\\{query\\}", options: []) else { return nil }
        var scheme = self
        while let match = pattern.matchesInString(scheme, options: [], range: NSMakeRange(0, NSString(string: scheme).length)).first {
            let l = scheme.startIndex.advancedBy(match.range.location)
            let r = l.advancedBy(match.range.length)
            let range = l..<r
            scheme.replaceRange(range, with: query)
        }
        
        return NSURL(string: scheme)
    }
    
    var validURL: NSURL? {
        return validURL("query")
    }
    
    var locked: Bool {
        return false
    }
}
