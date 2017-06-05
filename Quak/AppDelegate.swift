//
//  AppDelegate.swift
//  Quak
//
//  Created by 高炼 on 16/10/13.
//  Copyright © 2016年 mangonob. All rights reserved.
//

import UIKit
import MediaPlayer

let kDW_RootViewTag = -1
let kDW_InputViewTag = 1
let kDW_CollViewTag = 2
let kDW_NavigationBarTag = 4
let kDW_TextFieldTag = 8
let kDW_TableView = 16

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var performCustomSchemeflag: Bool?
    var tempDict: [String: AnyObject]?
    
    class func updateItems(application: UIApplication) {
        application.shortcutItems = DWItems.activiteItems.map { (dict) -> UIApplicationShortcutItem in
            let imgName = dict[kDWCUSTOM] == nil ? "\(dict[kDWTITLE]!)-m" : "Custom-m"
            return UIApplicationShortcutItem(type: "", localizedTitle: dict[kDWTITLE] as! String, localizedSubtitle: nil, icon: UIApplicationShortcutIcon(templateImageName: imgName), userInfo: dict)
        }.reverse()
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        AppDelegate.updateItems(application)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
        return true
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        application.keyWindow?.endEditing(true)
        application.keyWindow?.viewWithTag(kDW_RootViewTag)?.hidden = false
        application.keyWindow?.viewWithTag(kDW_CollViewTag)?.hidden = false
        application.keyWindow?.viewWithTag(kDW_InputViewTag)?.hidden = true
        
        application.keyWindow?.viewWithTag(kDW_NavigationBarTag)?.hidden = false
        tempDict = nil
    }
    
    func applicationWillTerminate(application: UIApplication) {
        trailingDealWith()
    }
    
    func applicationWillResignActive(application: UIApplication) {
        trailingDealWith()
    }
    
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        application.keyWindow?.backgroundColor = UIColor.whiteColor()
        performCustomSchemeflag = false
        application.keyWindow?.viewWithTag(kDW_CollViewTag)?.hidden = true
        application.keyWindow?.viewWithTag(kDW_NavigationBarTag)?.hidden = true
        application.keyWindow?.viewWithTag(kDW_RootViewTag)?.hidden = true
        
        guard let dict = shortcutItem.userInfo else { return }
        guard let scheme = (dict[kDWSCHEME] as? String) else { return }
        
        guard let haveQuery = try? NSRegularExpression(pattern: "\\{query\\}", options: []) else { return }
        let matches = haveQuery.matchesInString(scheme, options: [], range: NSMakeRange(0, NSString(string: scheme).length))
        guard matches.count == 0 else {
            performCustomSchemeflag = true
            application.keyWindow?.viewWithTag(kDW_InputViewTag)?.hidden = false
            application.keyWindow?.viewWithTag(kDW_TextFieldTag)?.becomeFirstResponder()
            (application.keyWindow?.viewWithTag(kDW_TableView) as? UITableView)?.reloadData()
            tempDict = dict
            completionHandler(true)
            return
        }
        
        guard let url = scheme.validURL else { return }
        
        if application.canOpenURL(url) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                application.openURL(url)
                completionHandler(true)
            })
        }
    }
    
    func trailingDealWith() {
        AppDelegate.updateItems(UIApplication.sharedApplication())
        DWItems.synthesize()
    }
}

