//
//  DesignableLabel.swift
//  PayBack
//
//  Created by Mohsin Surani on 11/09/17.
//  Copyright © 2017 Mohsin Surani. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableLabel: UILabel {

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
    
    @IBInspectable var maskToBounds: Bool = true {
        didSet {
            self.layer.masksToBounds = maskToBounds
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    //add padding to UIlabel
    @IBInspectable var topInset: CGFloat = 0.0
    @IBInspectable var bottomInset: CGFloat = 0.0
    @IBInspectable var leftInset: CGFloat = 0.0
    @IBInspectable var rightInset: CGFloat = 0.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    // Override `intrinsicContentSize` property for Auto layout code
    override var intrinsicContentSize: CGSize {
        let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + leftInset + rightInset
        let heigth = superContentSize.height + topInset + bottomInset
        return CGSize(width: width, height: heigth)
    }
}
