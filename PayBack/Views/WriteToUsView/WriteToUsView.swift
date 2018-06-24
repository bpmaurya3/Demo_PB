//
//  WriteToUsView.swift
//  PayBack
//
//  Created by Mohsin Surani on 13/12/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class WriteToUsView: UIView {

    @IBOutlet weak private var writetousView: DesignableLabel!
    @IBOutlet weak fileprivate var emailField: DesignableTFView!
    @IBOutlet weak fileprivate var mobileField: DesignableTFView!
    @IBOutlet weak fileprivate var messageField: DesignableTFView!
    @IBOutlet weak fileprivate var submitButton: UIButton!
    
    @IBOutlet weak fileprivate var cancelButton: UIButton!
    fileprivate let textviewPlaceHolder = NSLocalizedString("Message", comment: "Message")
    fileprivate let charcAllowed = NSLocalizedString("1000 characters max", comment: "1000 characters max")

    @IBOutlet weak private var textContentViews: UIView!
    @IBOutlet weak private var thankView: UIView!
    
    @IBOutlet weak private var tankyouIcon: UIImageView!
    @IBOutlet weak private var thankyouTitle: UILabel!
    @IBOutlet weak private var thankyouDescription: UILabel!
    fileprivate var placeHolderLabel: UILabel!

    var warningHandler: (() -> Void )?
    var cancelActionHandler: (() -> Void )?
    var submitActionHandler: ((_ email: String?, _ mobileNo: String?, _ message: String) -> Void )?
    
    var mobileTextFieldAction: ((CGFloat, CGFloat) -> Void )?
    var textViewAction: ((CGFloat, CGFloat) -> Void )?
    
    fileprivate func configureTextFields() {
        emailField
            .set(autoCapital: .none)
            .setToolbar(prevResponder: nil, nextResponder: self.mobileField)
            .addTextRule { (text) -> TextRuleResult in
                return TextRuleResult(withConditionResult: text.isNotEmpty() && text.isValidEmailId() ,
                                      failedMessage: NSLocalizedString("The email address you have entered is incorrect", comment: "A failure message telling the user that their email address should not be empty"))
        }
        
        mobileField
            .setToolbar(prevResponder: emailField, nextResponder: self.messageField)
            .addTextRule { (text) -> TextRuleResult in
                return TextRuleResult(withConditionResult: text.count == 10 && text.isNumberFormat() ,
                                      failedMessage: NSLocalizedString("The Mobile Number you have entered is incorrect", comment: "A failure message telling the user that their card/mobile number needs to be equal of 10 characters"))
                
        }
        configureMessageField()
    }
    fileprivate func configureMessageField() {
        messageField
            .set(warningFont: FontBook.Regular.of(size: 12))
            .setToolbar(prevResponder: mobileField, nextResponder: nil)
            .set(paddingAllAround: 15)
            .addTextRule { (text) -> TextRuleResult in
                var warningText = ""
                if text.isEmpty {
                    warningText = NSLocalizedString("Message should not be empty.", comment: "A failure message telling the user that their message should not be empty")
                }
                return TextRuleResult(withConditionResult: warningText.length == 0,
                                      failedMessage: warningText)
                
            }
            .textView.delegate = self
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        writetousView.backgroundColor = ColorConstant.backgroudColorBlue
        writetousView.font = FontBook.Bold.of(size: 17.0)
        writetousView.textColor = ColorConstant.textColorWhite
        
        emailField.inputTextColor = ColorConstant.writetoUsTextColor
        mobileField.inputTextColor = ColorConstant.writetoUsTextColor
        
        messageField.textView.textColor = ColorConstant.writetoUsTextColor
        messageField.textView.font = FontBook.Regular.ofTitleSize()
        messageField.warningInfo = charcAllowed

        submitButton.titleLabel?.font = FontBook.Regular.of(size: 11.0)
        submitButton.titleLabel?.textColor = ColorConstant.textColorWhite
        submitButton.backgroundColor = ColorConstant.buttonBackgroundColorPink
        cancelButton.titleLabel?.font = FontBook.Regular.of(size: 11.0)
        cancelButton.titleLabel?.textColor = ColorConstant.textColorWhite
        cancelButton.backgroundColor = ColorConstant.buttonBackgroundColorPink
       
        submitButton.isEnabled(state: false)
        
        configureTextFields()
        
        placeHolderLabel = UILabel(frame: CGRect(x: 19, y: 15, width: 100, height: 20))
        placeHolderLabel.font = FontBook.Regular.ofTitleSize()
        placeHolderLabel.text = textviewPlaceHolder
        messageField.textView.addSubview(placeHolderLabel)
        
        commonProperties(field: self.emailField, keyType: .emailAddress)
        commonProperties(field: self.mobileField, keyType: .numberPad)
    }
    
    private func commonProperties(field: DesignableTFView, keyType: UIKeyboardType) {
        let font = FontBook.Regular.ofTitleSize()
        let minFontSize: CGFloat = 10.0
        
        field
            .set(warningFont: FontBook.Regular.of(size: 12))
            .set(TFFont: font, minFontSize: minFontSize)
            .set(TFkeyboardType: keyType)
            .set(TFkeyboardReturnType: .next)
            .textField.delegate = self
        
        field.textField.addTarget(self, action: #selector(editingChangeAction(_:)), for: .editingChanged)
        field.warningInfo = " "
    }
    
    @objc func editingChangeAction(_ textField: UITextField) {
        self.satisfyAllFields()
    }
    
    func setViewsToHide(thankYouHide: Bool, model: WriteToUsModel?) {
        resetFields()
        textContentViews.isHidden = !thankYouHide
        thankView.isHidden = thankYouHide
        guard let model = model else {
            return
        }
        if let title = model.title {
            thankyouTitle.text = title
        }
        if let subTitle = model.subTitle {
            thankyouDescription.text = subTitle
        }
        if let timer = model.timer, timer != "", let delay = Double(timer) {
            self.hideThankYouView(after: delay)
        } else {
            self.hideThankYouView(after: 5)
        }
    }
    private func hideThankYouView(after delay: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.thankView.isHidden = true
            self.textContentViews.isHidden = false
            self.cancelAction(self.cancelButton)
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.endEditing(false)
        resetFields()
        cancelActionHandler?()
    }
    
    @IBAction func submitAction(_ sender: Any) {
        self.endEditing(false)
        submitActionHandler?(emailField.textField.text, mobileField.textField.text, messageField.textView.text)
    }
    
    fileprivate func satisfyAllFields() {
        submitButton.isEnabled(state: emailField.satisfiesAllTextRules() && mobileField.satisfiesAllTextRules() && messageField.satisfiesTextViewTextRules())
    }
    
    func resetFields() {
        self.emailField.textField.text = ""
        self.mobileField.textField.text = ""
        self.messageField.textView.text = ""
        self.placeHolderLabel.isHidden = false
        
        emailField.clearInlineError()
        mobileField.clearInlineError()
        messageField.clearInlineError()
        
        emailField.warningInfo = " "
        mobileField.warningInfo = " "
        
        messageField.warningTextColor = .lightGray
        messageField.warningInfo = charcAllowed
        
        messageField.set(textViewText: "")
        
        submitButton.isEnabled(state: false)
    }
}

extension WriteToUsView: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == emailField.textField {
            mobileTextFieldAction?(emailField.frame.origin.y, emailField.frame.height)
            emailField.clearInlineError()
            emailField.warningInfo = " "
        } else {
            mobileTextFieldAction?(mobileField.frame.origin.y, mobileField.frame.height)
            mobileField.clearInlineError()
            mobileField.warningInfo = " "
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let text = textField.text, text.isNotEmpty() {
            if textField == emailField.textField {
                emailField.applyAllTextRules()
            } else {
                mobileField.applyAllTextRules()
            }
        }
        
        warningHandler?()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField.textField {
            mobileField.textField.becomeFirstResponder()
        } else if textField == mobileField.textField {
            messageField.textView.becomeFirstResponder()
        }

        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField.textInputMode == nil {
            return false
        }
        
        if let mobileno = mobileField.textField.text, textField == mobileField.textField {
            let newLength = mobileno.count + string.count - range.length
            return string.allowNumbersOnly() && newLength <= 10
        }
        
        if textField == emailField.textField {
            if string >= "A" && string <= "Z" {
                textField.insertText(string.lowercased())
                return false
            }
            return true
        }
        
        return true
    }
}

extension WriteToUsView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        //placeHolderLabel.isHidden = true
        textViewAction?(messageField.frame.origin.y, messageField.frame.height)
        messageField.clearInlineError()
        messageField.warningTextColor = .lightGray
        messageField.warningInfo = charcAllowed
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            placeHolderLabel.isHidden = false
        } else {
            if messageField.satisfiesTextViewTextRules() {
                messageField.warningTextColor = .lightGray
                messageField.warningInfo = charcAllowed
            } else {
                messageField.warningTextColor = .red
                messageField.applyAllTextViewRules()
            }
        }        
    }
    func textViewDidChange(_ textView: UITextView) {
        UIView.animate(withDuration: 0.0) {
            self.placeHolderLabel.isHidden = textView.text.isEmpty ? false : true
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        var textviewText = textView.text ?? ""
        
        if text == "" && textviewText != "" {
            textviewText.removeLast()
        } else {
            textviewText.append(text)
        }
        
        messageField.set(textViewText: textviewText)
        self.satisfyAllFields()
        return textView.text.count + (text.count - range.length) <= 1000
    }
}
