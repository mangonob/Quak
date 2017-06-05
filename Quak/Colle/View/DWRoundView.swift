//
//  DWRoundView.swift
//  Quak
//
//  Created by 高炼 on 16/10/19.
//  Copyright © 2016年 mangonob. All rights reserved.
//

import UIKit

class DWRoundView: UIView {
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        layer.masksToBounds = true
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width / (120 / 25.0)
    }
}
