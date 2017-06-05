//
//  DWWidgetView.swift
//  Quak
//
//  Created by 高炼 on 16/10/20.
//  Copyright © 2016年 mangonob. All rights reserved.
//

import UIKit

class DWWidgetView: UIView {
    weak var view: UIView?
    
    var shown: Bool {
        return view != nil
    }
    
    class func loadView() -> DWWidgetView {
        guard let v = NSBundle.mainBundle().loadNibNamed("DWWidgetView", owner: nil, options: nil)?.first as? DWWidgetView else {
            fatalError("Initial DWWidgetView Faild\(#function)")
        }
        return v
    }
    
    func showIn(viewController vc: UIViewController, animated: Bool) {
        guard !shown else { return }
        hide(false)
        alpha = 1
        view = vc.view
        view?.addSubview(self)
        
        translatesAutoresizingMaskIntoConstraints = false
        view?.addConstraints([
            NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 64),
            NSLayoutConstraint(item: self, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 16),
            NSLayoutConstraint(item: self, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: -16),
            NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: vc.topLayoutGuide, attribute: .Bottom, multiplier: 1, constant: 8),
            ])
        
        if animated {
            let ani1 = CABasicAnimation(keyPath: "transform.scale.y")
            ani1.fromValue = 0
            let ani2 = CABasicAnimation(keyPath: "opacity")
            ani2.fromValue = 0
            let  ag = CAAnimationGroup()
            ag.animations = [ani1, ani2]
            ag.duration = 0.3
            ag.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            layer.addAnimation(ag, forKey: nil)
        }
    }
    
    func clearConstraintFromSuper() {
        view?.removeConstraints(
            view?.constraints.filter({ (cons) -> Bool in
                return cons.firstItem === self || cons.secondItem === self
            }) ?? []
        )
    }
    
    func hide(animated: Bool) {
        guard shown else { return }
        if !animated {
            clearConstraintFromSuper()
            removeFromSuperview()
            view = nil
        } else {
            UIView.animateWithDuration(0.25, animations: {
                self.alpha = 0
                }, completion: { (_) in
                    self.clearConstraintFromSuper()
                    self.removeFromSuperview()
                    self.view = nil
            })
        }
    }
}














