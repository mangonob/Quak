//
//  UIView+.swift
//  Quak
//
//  Created by 高炼 on 16/10/20.
//  Copyright © 2016年 mangonob. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    //MARK: - Animate
    func shake() {
        let ani1 = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        let delta = M_PI / 32
        ani1.duration = 0.12
        ani1.values = [0, -delta, 0, delta, 0]
        ani1.keyTimes = [0, 0.25, 0.5, 0.75, 1.0]
        ani1.repeatCount = 3
        layer.addAnimation(ani1, forKey: nil)
    }
    
    func swing() {
        let ani1 = CAKeyframeAnimation(keyPath: "transform.translation.x")
        let delta = 5
        ani1.duration = 0.12
        ani1.beginTime = CACurrentMediaTime() + CFTimeInterval((CGFloat(arc4random()) / CGFloat(UINT32_MAX)) * 0.12)
        ani1.values = [0, -delta, 0, delta, 0]
        ani1.keyTimes = [0, 0.25, 0.5, 0.75, 1.0]
        ani1.repeatCount = 3
        layer.addAnimation(ani1, forKey: nil)
    }
}
