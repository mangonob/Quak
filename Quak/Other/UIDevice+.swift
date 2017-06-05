//
//  UIDevice+.swift
//  MindMap
//
//  Created by 高炼 on 16/9/22.
//  Copyright © 2016年 mangonob. All rights reserved.
//

import UIKit

extension UIDevice {
    static func Pad(action: (() -> ())?) -> UIDevice.Type {
        guard UIDevice.currentDevice().userInterfaceIdiom == .Pad else { return self }
        action?()
        return self
    }
    
    static func notPad(action: (() -> ())?) -> UIDevice.Type {
        guard UIDevice.currentDevice().userInterfaceIdiom != .Pad else { return self }
        action?()
        return self
    }
    
    static func Phone(action: (() -> ())?) -> UIDevice.Type {
        guard UIDevice.currentDevice().userInterfaceIdiom == .Phone else { return self }
        action?()
        return self
    }
}