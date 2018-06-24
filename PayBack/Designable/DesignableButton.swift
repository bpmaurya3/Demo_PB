//
//  DesignableButton.swift
//  PayBack
//
//  Created by Mohsin Surani on 11/09/17.
//  Copyright © 2017 Mohsin Surani. All rights reserved.
//

import QuartzCore
import UIKit

@IBDesignable
class DesignableButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable var maskToBounds: Bool = true {
        didSet {
            self.layer.masksToBounds = maskToBounds
        }
    }
}
