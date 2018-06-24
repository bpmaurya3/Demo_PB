//
//  SwitchView.swift
//  CustomSwitch
//
//  Created by Bhuvanendra Pratap Maurya on 9/11/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class SwitchView: UIView {
    
    var thumbImageView: UIImageView!
    var titleLable: UILabel!
    
    @IBInspectable open dynamic var trackOffFillColor: UIColor? { // UI_APPEARANCE_SELECTOR
        get { return self._trackOffFillColor }
        set {
            self._trackOffFillColor = newValue
            self.backgroundColor = ColorConstant.backgroudColorBlue
        }
    }
    fileprivate var _trackOffFillColor: UIColor?
    
    fileprivate var thumbDiameter: CGFloat?

    fileprivate var cornerRadius: CGFloat?
   
    fileprivate var thumbCornerRadius: CGFloat?
    
    @IBInspectable open dynamic var thumbImage: UIImage {
        get { return self._thumbImage }
        set {
            self._thumbImage = newValue
            
            self.thumbImageView.image = _thumbImage
        }
    }
    fileprivate var _thumbImage: UIImage
    
    @IBInspectable open dynamic var titleFontSize: CGFloat {
        get { return self._titleFontSize }
        set {
            self._titleFontSize = newValue
            
            self.titleLable.font = FontBook.Medium.of(size: _titleFontSize) //UIFont.systemFont(ofSize: _titleFontSize)
            self.titleLable.adjustsFontSizeToFitWidth = true
            self.titleLable.minimumScaleFactor = 0.5
        }
    }
    fileprivate var _titleFontSize: CGFloat
    
    let scale = UIScreen.main.scale
    
    override public init(frame: CGRect) {
        self._thumbImage = UIImage()
        self._titleFontSize = 12
        super.init(frame: frame)
        
        baseInit()
    }
    
    required public init(coder aDecoder: NSCoder) {
        self._thumbImage = UIImage()
        self._titleFontSize = 12

        super.init(coder: aDecoder)!
        
        baseInit()
    }
    
    public init() {
        self._thumbImage = UIImage()
        self._titleFontSize = 12

        super.init(frame: CGRect.zero)
        
        baseInit()
    }
    
    fileprivate func baseInit() {
        clipsToBounds = false
        
        //init default style
        self._trackOffFillColor = UIColor.clear
        self.backgroundColor = ColorConstant.primaryColorBlue
        
        thumbImageView = UIImageView()
        thumbImageView.contentMode = .scaleAspectFill
        thumbImageView.clipsToBounds = true
        thumbImageView.backgroundColor = .clear
        self.addSubview(thumbImageView)
        
        titleLable = UILabel()
        titleLable.backgroundColor = .clear
        titleLable.text = ""
        titleLable.textColor = .white
        titleLable.textAlignment = .center
        titleLable.numberOfLines = 1
        titleLable.backgroundColor = .clear
        self.addSubview(titleLable)
        
        DispatchQueue.main.async { [weak self] in
            if let strongself = self {
                strongself.thumbDiameter = strongself.frame.height
                strongself.cornerRadius = strongself.frame.height / 2
                strongself.layer.cornerRadius = strongself.cornerRadius!
                strongself.thumbCornerRadius = strongself.layer.cornerRadius
                strongself.thumbImageView.layer.cornerRadius = strongself.thumbCornerRadius!
                
                strongself.thumbImageView.frame = strongself.getThumbOffRect()
                strongself.titleLable.frame = strongself.getTitleLabelRect()
            }
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
    }
    
    fileprivate func getThumbOffRect() -> CGRect {
        return CGRect(x: (frame.height - thumbDiameter!) / 2.0, y: (frame.height - thumbDiameter!) / 2.0, width: thumbDiameter!, height: thumbDiameter!)
    }
    
    fileprivate func getTitleLabelRect() -> CGRect {
        return CGRect(x: thumbDiameter! + 5, y: 0, width: frame.width - (thumbDiameter! + thumbDiameter! / 2), height: frame.height)
    }
    
    //helper func
    fileprivate func UIColorFromRGB(_ rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
