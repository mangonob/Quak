//
//  DWIconCell.swift
//  Quak
//
//  Created by 高炼 on 16/10/14.
//  Copyright © 2016年 mangonob. All rights reserved.
//

import UIKit

class DWIconCell: UICollectionViewCell {
    @IBOutlet weak var thumbView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var background: UIView!
    
    var custom = false
    
    var userInteracted = false
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        thumbView.layer.masksToBounds = true
        thumbView.contentMode = .ScaleToFill
    }
    
    var bold = false {
        didSet {
            if bold {
                background.layer.borderColor = UIColor.blackColor().CGColor
                let ani = CABasicAnimation(keyPath: "borderWidth")
                ani.fromValue = background.layer.borderWidth
                ani.toValue = bounds.width / 2 + 1
                ani.duration = 0.15
                if userInteracted {
                    background.layer.addAnimation(ani, forKey: nil)
                }
                background.layer.borderWidth = bounds.width / 2 + 1
            } else {
                background.layer.borderColor = UIColor.blackColor().CGColor
                let ani = CABasicAnimation(keyPath: "borderWidth")
                ani.fromValue = background.layer.borderWidth
                ani.toValue = 1
                ani.duration = 0.15
                if userInteracted {
                    background.layer.addAnimation(ani, forKey: nil)
                }
                background.layer.borderWidth = 1
            }
            userInteracted = false
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        let ani = CABasicAnimation(keyPath: "transform.scale")
        ani.toValue = 0.9
        ani.duration = 0.2
        ani.autoreverses = true
        layer.addAnimation(ani, forKey: "began")
    }
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        guard let hit = super.hitTest(point, withEvent: event) else {
            return nil
        }
        return self
    }
}
