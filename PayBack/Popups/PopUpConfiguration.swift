//
//  PopUpConfiguration.swift
//  PaybackPopup
//
//  Created by Mohsin.Surani on 17/08/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation
import UIKit

final internal class PopUpConfiguration {
    
    // MARK: alert pop up Values
    
    private(set) var popUpBackgroundColor: UIColor = .white
    private(set) var titleBackGroundColor: UIColor = UIColor(red: 237 / 255, green: 1 / 255, blue: 108 / 255, alpha: 1)
    
    private(set) var titleString = "Account Blocked"
    private(set) var descriptionString = "Your account has been blocked temporarily. Please try again after some times."
    private(set) var cancelString = "Cancel"
    private(set) var okString = "Ok"
    private(set) var confirmString = "Confirm"
    
    private(set) var showCancel = false
    private(set) var showConfirm = false
    private(set) var showOk = true
    
     // MARK: Coupon pop up Values
    private(set) var popCouponBackgroundColor: UIColor = .white
    private(set) var titleCouponBackGroundColor: UIColor = UIColor(red: 237 / 255, green: 1 / 255, blue: 108 / 255, alpha: 1)
    private(set) var copyBackColor: UIColor = UIColor(red: 237 / 255, green: 1 / 255, blue: 108 / 255, alpha: 1)
    private(set) var instructionBackColor: UIColor = UIColor(red: 228 / 255, green: 242 / 255, blue: 253 / 255, alpha: 1)
    
    private(set) var hideCopy = false
    private(set) var hideInstruction = false
    private(set) var hideDescriptionCoupon = false
    private(set) var hideOfferCode = false
    private(set) var hideClose = false
    private(set) var enableCopy = true
    
    private(set) var titleCouponString = "COUPON"
    private(set) var descriptionCouponString = ""
    private(set) var offerCouponString = "FLIPKART 2018"
    private(set) var copyCodeString = "COPY CODE"
    private(set) var instructionString = "Only one offer can be availed per transaction."
    
    // MARK: Password pop up Values
    private(set) var popPasswordBackgroundColor: UIColor = .white
    private(set) var titlePasswordBackGroundColor: UIColor = UIColor(red: 237 / 255, green: 1 / 255, blue: 108 / 255, alpha: 1)
    private(set) var pinBackColor: UIColor = UIColor(red: 237 / 255, green: 1 / 255, blue: 108 / 255, alpha: 1)
    private(set) var textFieldBorderColor: UIColor = .gray
    
    private(set) var hidePaswordInstruction = false
    private(set) var hideDescriptionPassword = false
    private(set) var hideClosePasswordPopUp = false
    private(set) var needAttributeAction = true
    
    private(set) var titlePasswordString = "COUPON"
    private(set) var descriptionPasswordString = ""
    private(set) var pinGenerateString = "GENERATE PIN"
    private(set) var otpString = ""
    private(set) var otpPlaceholderString = "Please Enter Otp"
    private(set) var errorMessage = ""
    private(set) var textFieldText: String = ""
    private(set) var isDOBViewDisplay = false
    private(set) var isMessageDisplay = false
    //swiftlint:disable colon
    private(set) var instructionPasswordString = NSAttributedString(string: "Hello.", attributes: [NSAttributedStringKey.foregroundColor: UIColor.green])
    //swiftlint:enable colon
    
    private(set) var textRules: (length: Int, message: String) = (0, "")
    @discardableResult
    func textRule(_ rule: (length: Int, message: String)) -> Self {
        textRules = rule
        return self
    }
    // MARK: Alertpopup Methods Starts
    // MARK: Hide and Show Values
    @discardableResult
    func set(hideCancelButton: Bool) -> Self {
        self.showCancel = hideCancelButton
        return self
    }
    
    @discardableResult
    func set(diplayDOB display: Bool) -> Self {
        self.isDOBViewDisplay = display
        return self
    }
    
    @discardableResult
    func set(messageLabel display: Bool) -> Self {
        self.isMessageDisplay = display
        return self
    }
    
    @discardableResult
    func set(hideConfirmButton: Bool) -> Self {
        self.showConfirm = hideConfirmButton
        return self
    }
    
    @discardableResult
    func set(hideOkButton: Bool) -> Self {
        self.showOk = hideOkButton
        return self
    }
    
    // MARK: setAllValues
    @discardableResult
    func set(cancelText: String) -> Self {
        self.cancelString = cancelText
        return self
    }
    
    @discardableResult
    func set(okText: String) -> Self {
        self.okString = okText
        return self
    }
    
    @discardableResult
    func set(confirmText: String) -> Self {
        self.confirmString = confirmText
        return self
    }
    
    @discardableResult
    func set(titleText: String) -> Self {
        self.titleString = titleText
        return self
    }
    
    @discardableResult
    func set(desText: String) -> Self {
        self.descriptionString = desText
        return self
    }
    
    // MARK: setUIColors
    @discardableResult
    func set(titleBackColor: UIColor) -> Self {
        self.titleBackGroundColor = titleBackColor
        return self
    }
    
    @discardableResult
    func set(popUpBackColor: UIColor) -> Self {
        self.popUpBackgroundColor = popUpBackColor
        return self
    }
    // MARK: Alertpopup Methods Ends
    
    // MARK: AlertCoupon Methods Starts
    // MARK: Hide and Show Values
    @discardableResult
    func set(hideDescription: Bool) -> Self {
        self.hideDescriptionCoupon = hideDescription
        return self
    }
    
    @discardableResult
    func set(hideOfferCode: Bool) -> Self {
        self.hideOfferCode = hideOfferCode
        return self
    }
    
    @discardableResult
    func set(hideInstruction: Bool) -> Self {
        self.hideInstruction = hideInstruction
        return self
    }
    
    @discardableResult
    func set(hideCopy: Bool) -> Self {
        self.hideCopy = hideCopy
        return self
    }
    
    @discardableResult
    func set(hideClose: Bool) -> Self {
        self.hideClose = hideClose
        return self
    }
    
    // MARK: set Colors of coupon alert
    @discardableResult
    func set(titleCouponBackColor: UIColor) -> Self {
        self.titleCouponBackGroundColor = titleCouponBackColor
        return self
    }
    
    @discardableResult
    func set(popUpCouponBackColor: UIColor) -> Self {
        self.popCouponBackgroundColor = popUpCouponBackColor
        return self
    }
    
    @discardableResult
    func set(copyBackColor: UIColor) -> Self {
        self.copyBackColor = copyBackColor
        return self
    }
    
    @discardableResult
    func set(instructionBackColor: UIColor) -> Self {
        self.instructionBackColor = instructionBackColor
        return self
    }
    
    // MARK: set all strings in Coupon alert
    
    @discardableResult
    func set(titleCouponText: String) -> Self {
        self.titleCouponString = titleCouponText
        return self
    }
    
    @discardableResult
    func set(descriptionCouponText: String) -> Self {
        self.descriptionCouponString = descriptionCouponText
        return self
    }
    
    @discardableResult
    func set(offerCouponString: String) -> Self {
        self.offerCouponString = offerCouponString
        return self
    }
    
    @discardableResult
    func set(copyCodeString: String) -> Self {
        self.copyCodeString = copyCodeString
        return self
    }
    
    @discardableResult
    func set(instructionString: String) -> Self {
        if instructionString != "" {
            self.instructionString = instructionString
        }
        return self
    }
    // MARK: AlertCoupon Methods Ends
    
    // MARK: AlertPassword Methods Starts
    // MARK: Hide and Show Values
    
    @discardableResult
    func set(hidePasswordInstruction: Bool) -> Self {
        self.hidePaswordInstruction = hidePasswordInstruction
        return self
    }
    
    @discardableResult
    func set(hideDescriptionPassword: Bool) -> Self {
        self.hideDescriptionPassword = hideDescriptionPassword
        return self
    }
    
    @discardableResult
    func set(hideClosePasswordPopUp: Bool) -> Self {
        self.hideClosePasswordPopUp = hideClosePasswordPopUp
        return self
    }
    @discardableResult
    func set(needAttributeAction: Bool) -> Self {
        self.needAttributeAction = needAttributeAction
        return self
    }
    
    // MARK: set all colors of password pop up
    
    @discardableResult
    func set(popPasswordBackgroundColor: UIColor) -> Self {
        self.popPasswordBackgroundColor = popPasswordBackgroundColor
        return self
    }
    
    @discardableResult
    func set(titlePasswordBackGroundColor: UIColor) -> Self {
        self.titlePasswordBackGroundColor = titlePasswordBackGroundColor
        return self
    }
    
    @discardableResult
    func set(pinBackColor: UIColor) -> Self {
        self.pinBackColor = pinBackColor
        return self
    }
    @discardableResult
    func set(textFieldBorderColor: UIColor) -> Self {
        self.textFieldBorderColor = textFieldBorderColor
        return self
    }
    // MARK: set all values of password pop up
    
    @discardableResult
    func set(titlePasswordString: String) -> Self {
        self.titlePasswordString = titlePasswordString
        return self
    }
    
    @discardableResult
    func set(descriptionPasswordString: String) -> Self {
        self.descriptionPasswordString = descriptionPasswordString
        return self
    }
    
    @discardableResult
    func set(pinGenerateString: String) -> Self {
        self.pinGenerateString = pinGenerateString
        return self
    }
    
    @discardableResult
    func set(otpString: String) -> Self {
        self.otpString = otpString
        return self
    }
    
    @discardableResult
    func set(otpPlaceholderString: String) -> Self {
        self.otpPlaceholderString = otpPlaceholderString
        return self
    }
    @discardableResult
    func set(errorMessage: String) -> Self {
        self.errorMessage = errorMessage
        return self
    }
    
    @discardableResult
    func set(instructionPasswordString: NSAttributedString) -> Self {
        self.instructionPasswordString = instructionPasswordString
        return self
    }
    @discardableResult
    func set(textFieldText text: String) -> Self {
        self.textFieldText = text
        return self
    }
    
}
