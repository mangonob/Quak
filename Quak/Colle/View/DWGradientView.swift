//
//  DWGradientView.swift
//  MindMap
//
//  Created by 高炼 on 16/9/27.
//  Copyright © 2016年 mangonob. All rights reserved.
//

import UIKit

@IBDesignable class DWGradientView: UIView {
    @IBInspectable var color1: UIColor? { didSet { update() } }
    @IBInspectable var color2: UIColor? { didSet { update() } }
    @IBInspectable var start: CGPoint = CGPoint(x: 0.5, y: 0) { didSet { update() } }
    @IBInspectable var end: CGPoint = CGPoint(x: 0.5, y: 1) { didSet { update() } }
    
    var gradientLayer = CAGradientLayer()
    
    private var once = dispatch_once_t()
    override func layoutSubviews() {
        super.layoutSubviews()
        dispatch_once(&once) {
            guard let layer = self.layer as? CAGradientLayer else { return }
            layer.locations = [0, 1]
            update()
        }
    }
    
    func update() {
        guard let layer = self.layer as? CAGradientLayer else { return }
        layer.colors = [
            (color1 ?? UIColor.dwTurquoiseBlueColor()).CGColor,
            (color2 ?? UIColor.dwCeruleanColor()).CGColor
        ]
        layer.startPoint = start
        layer.endPoint = end
    }
    
    override class func layerClass() -> AnyClass {
        return CAGradientLayer.classForCoder()
    }
}
