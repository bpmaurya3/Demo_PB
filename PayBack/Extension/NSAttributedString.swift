//
//  NSAttributedString.swift
//  PayBack
//
//  Created by Mohsin Surani on 08/11/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation
import UIKit

extension NSAttributedString {
    
    class func getAttributedStringForInfo(staticText: String, changingValues: String) -> NSAttributedString {
        
        let staticValue = NSMutableAttributedString(string: "\(staticText) : ", attributes: [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont(name: "Arial-BoldMT", size: 15) as Any])
        
        let changingText = NSMutableAttributedString(string: "\(changingValues) ", attributes: [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont(name: "Arial", size: 15) as Any])
        
        let combination = NSMutableAttributedString()
        
        combination.append(staticValue)
        combination.append(changingText)
        
        return combination
    }
    
    class func getAttributedStringForFreeDelivery(staticText: String, changingValues: String) -> NSAttributedString {
        
        let staticValue = NSMutableAttributedString(string: "\(staticText)", attributes: [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: FontBook.Bold.of(size: 12) as Any])
        
        let changingText = NSMutableAttributedString(string: "\(changingValues) ", attributes: [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: FontBook.Regular.of(size: 12) as Any])
        
        let combination = NSMutableAttributedString()
        
        combination.append(staticValue)
        combination.append(changingText)
        
        return combination
    }
    
    class func getAttributedStringForEstDelivery(staticText: String, changingValues: String) -> NSAttributedString {
        
        let staticValue = NSMutableAttributedString(string: "\(staticText)", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: FontBook.Bold.of(size: 12) as Any])
        
        let changingText = NSMutableAttributedString(string: "\(changingValues) ", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: FontBook.Regular.of(size: 12) as Any])
        
        let combination = NSMutableAttributedString()
        
        combination.append(staticValue)
        combination.append(changingText)
        
        return combination
    }
    
    class func getAttributedStringForShippingAddress(name: String, changingValues: String) -> NSAttributedString {
        
        let staticValue = NSMutableAttributedString(string: "Shipping Address : \n\n", attributes: [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont(name: "Arial-BoldMT", size: 15) as Any])
        
        let nameText = NSMutableAttributedString(string: "\(name)\n", attributes: [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont(name: "Arial-BoldMT", size: 15) as Any])
        
        let changingText = NSMutableAttributedString(string: "\(changingValues) ", attributes: [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont(name: "Arial", size: 15) as Any])
        
        let combination = NSMutableAttributedString()
        
        combination.append(staticValue)
        combination.append(nameText)
        combination.append(changingText)
        
        return combination
    }
    
   class func getAttributedStringForAddress(name: String, changingValues: String) -> NSAttributedString {
    
        let nameText = NSMutableAttributedString(string: "\(name)\n", attributes: [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: FontBook.Medium.of(size: 12) as Any])
        
        let changingText = NSMutableAttributedString(string: "\(changingValues) ", attributes: [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: FontBook.Regular.of(size: 12) as Any])
        
        let combination = NSMutableAttributedString()
        
        combination.append(nameText)
        combination.append(changingText)
        
        return combination
    }
    
    class func getAttributedTextForRoom(changingValues: String) -> NSAttributedString {
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = .center
        
        let queText = NSMutableAttributedString(string: "\(StringConstant.rsSymbol)", attributes: [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: FontBook.Regular.of(size: 19) as Any, NSAttributedStringKey.paragraphStyle: titleParagraphStyle])
        
        let valueText = NSMutableAttributedString(string: "\(changingValues) ", attributes: [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: FontBook.Black.of(size: 19) as Any, NSAttributedStringKey.paragraphStyle: titleParagraphStyle])
        
        let QuestionText = NSMutableAttributedString(string: "\nper month", attributes: [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: FontBook.Regular.of(size: 10.5) as Any, NSAttributedStringKey.paragraphStyle: titleParagraphStyle])
        
        let combination = NSMutableAttributedString()
        
        combination.append(queText)
        combination.append(valueText)
        combination.append(QuestionText)
        
        return combination
    }
    
    class func getAttributedTextforPoint(changingValues: String) -> NSAttributedString {
        
        let dateText = NSMutableAttributedString(string: "ºP\(changingValues) ", attributes: [NSAttributedStringKey.foregroundColor: ColorConstant.footerTextColor, NSAttributedStringKey.font: FontBook.Black.of(size: 24) as Any])
        
        let QuestionText = NSMutableAttributedString(string: "\nper month", attributes: [NSAttributedStringKey.foregroundColor: ColorConstant.footerTextColor, NSAttributedStringKey.font: FontBook.Regular.of(size: 13) as Any])
        
        let combination = NSMutableAttributedString()
        
        combination.append(dateText)
        combination.append(QuestionText)
        
        return combination
    }
    
    class func getAttributedTextforPointAway(changingValues: String) -> NSAttributedString {
        
        let staticText1 = NSMutableAttributedString(string: "You are ", attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray, NSAttributedStringKey.font: FontBook.Medium.of(size: 15) as Any])
        
        let changeValues = NSMutableAttributedString(string: "\(changingValues) ", attributes: [NSAttributedStringKey.foregroundColor: ColorConstant.shopNowButtonBGColor, NSAttributedStringKey.font: FontBook.Bold.of(size: 15) as Any])
        
        let staticText2 = NSMutableAttributedString(string: "away from your wish", attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray, NSAttributedStringKey.font: FontBook.Medium.of(size: 15) as Any])
        
        let combination = NSMutableAttributedString()
        
        combination.append(staticText1)
        combination.append(changeValues)
        combination.append(staticText2)
        
        return combination
    }
    
    class func getUnderLineText(string: String, color: UIColor) -> NSAttributedString {
        
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: string, attributes: [NSAttributedStringKey.foregroundColor: color])
        attributedString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 0, length: attributedString.length))
        return attributedString
    }
    
}
