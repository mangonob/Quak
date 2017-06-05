//
//  UIColor+.swift
//  Quak
//
//  Created by 高炼 on 16/10/14.
//  Copyright © 2016年 mangonob. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class func dwTealBlueColor() -> UIColor {
        return UIColor(red: 0.0, green: 121.0 / 255.0, blue: 168.0 / 255.0, alpha: 1.0)
    }
    
    class func dwGreenblueColor() -> UIColor {
        return UIColor(red: 34.0 / 255.0, green: 210.0 / 255.0, blue: 158.0 / 255.0, alpha: 1.0)
    }
    
    class func dwPinkishRedColor() -> UIColor {
        return UIColor(red: 235.0 / 255.0, green: 12.0 / 255.0, blue: 55.0 / 255.0, alpha: 1.0)
    }
    
    class func dwWarmGreyColor() -> UIColor {
        return UIColor(white: 136.0 / 255.0, alpha: 1.0)
    }
    
    class func dwTealishColor() -> UIColor {
        return UIColor(red: 41.0 / 255.0, green: 187.0 / 255.0, blue: 156.0 / 255.0, alpha: 1.0)
    }
    
    class func dwCeruleanColor() -> UIColor {
        return UIColor(red: 0.0, green: 112.0 / 255.0, blue: 220.0 / 255.0, alpha: 1.0)
    }
    
    class func dwTurquoiseBlueColor() -> UIColor {
        return UIColor(red: 0.0, green: 176.0 / 255.0, blue: 219.0 / 255.0, alpha: 1.0)
    }
    
    class func dwMarigoldColor() -> UIColor {
        return UIColor(red: 255.0 / 255.0, green: 198.0 / 255.0, blue: 8.0 / 255.0, alpha: 1.0)
    }
}

extension UIColor {
    func darken(rate: CGFloat) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        b = min(b * (1 - rate / 100), 1.0)
        return UIColor(hue: h, saturation: s, brightness: b, alpha: a)
    }
    
    func lighten(rate: CGFloat) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        b = min(b * (1 + rate / 100), 1.0)
        return UIColor(hue: h, saturation: s, brightness: b, alpha: a)
    }
}
