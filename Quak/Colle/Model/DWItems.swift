//
//  DWItems.swift
//  Quak
//
//  Created by 高炼 on 16/10/17.
//  Copyright © 2016年 mangonob. All rights reserved.
//

import UIKit

let kDWSCHEME = "scheme"
let kDWACTIVE = "active"
let kDWLOCKED = "locked"
let kDWTITLE =  "title"
let kDWTIMESTAMP = "timestamp"

// no value in schemes.plist
let kDWCUSTOM = "custom"

typealias ItemColl = [[String: AnyObject]];
class DWItems: NSObject {
    private static var once = dispatch_once_t()
    private static var _items: ItemColl!;
    static var items: ItemColl {
        get {
            dispatch_once(&once) {
                guard var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first else { return }
                
                path.appendContentsOf("/schemes.plist")
                
                if !NSFileManager.defaultManager().fileExistsAtPath(path) {
                    path = NSBundle.mainBundle().pathForResource("schemes", ofType: "plist")!
                }
                
                guard let arr = NSArray(contentsOfFile: path) as? ItemColl else { return }
                _items = arr
            }
            return _items
        }
        set {
            _items = newValue
        }
    }
    
    static func invalid() {
        _validItems = nil
    }
    
    private static var _validItems: ItemColl!
    static var validItems: ItemColl {
        get {
            if _validItems == nil {
                _validItems = items.filter({ (dic) -> Bool in
                    guard let scheme = dic[kDWSCHEME] as? String else { return false }
                    guard let url = scheme.validURL else { return false }
                    return UIApplication.sharedApplication().canOpenURL(url)
                })
            }
            return _validItems
        }
    }
    
    static var activiteItems: ItemColl {
        return validItems.filter { (dict) -> Bool in
            guard let active = dict[kDWACTIVE] as? Bool else { return false }
            return active
            }.sort({ (left, right) -> Bool in
                guard let lt = left[kDWTIMESTAMP] as? NSTimeInterval, rt = right[kDWTIMESTAMP] as? NSTimeInterval else { return false }
                return lt < rt
            })
    }
    
    static func containsTitle(title: String, whitePaper: [String]) -> Bool {
        var flag = false
        _items.forEach { (dict) in
            guard let t = dict[kDWTITLE] as? String else { return }
            if t == title && !whitePaper.contains(t) {
                flag = true
            }
        }
        return flag
    }
    static func synthesize() {
        guard var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first else { return }
        path.appendContentsOf("/schemes.plist")
        
        let dicts = NSArray(array: _items)
        dicts.writeToFile(path, atomically: true)
    }
    
}




