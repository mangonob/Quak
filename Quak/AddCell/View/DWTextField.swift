//
//  DWTextField.swift
//  Quak
//
//  Created by 高炼 on 16/10/18.
//  Copyright © 2016年 mangonob. All rights reserved.
//

import UIKit

@IBDesignable class DWTextField: UITextField {
    @IBInspectable var borderColor: UIColor = UIColor.whiteColor() {
        didSet {
            layer.borderColor = borderColor.CGColor
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

    @IBInspectable var placeholderColor: UIColor = UIColor.whiteColor() {
        didSet {
            guard let ap = attributedPlaceholder else { return }
            let newAp = NSMutableAttributedString(attributedString: ap)
            let s = NSString(string: newAp.string)
            let range = NSRange(location: 0, length: s.length)
            newAp.addAttributes([NSForegroundColorAttributeName: placeholderColor], range: range)
            attributedPlaceholder = newAp
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
}
