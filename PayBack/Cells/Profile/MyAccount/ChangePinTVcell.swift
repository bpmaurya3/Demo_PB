//
//  ChangePinTVcell.swift
//  PayBack
//
//  Created by Dinakaran M on 05/10/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class ChangePinTVcell: UITableViewCell {
    
    @IBOutlet weak fileprivate var oldPinField: DesignableTFView!
    @IBOutlet weak fileprivate var newPinField: DesignableTFView!
    @IBOutlet weak fileprivate var confirmPinField: DesignableTFView!
    
    var warningHandler: (() -> Void )?
    fileprivate var validationHandler: ((Bool) -> Void)? = { _ in }
    
    var oldPinHandler: ((CGFloat, CGFloat) -> Void )?
    var newPinHandler: ((CGFloat, CGFloat) -> Void )?
    var confirmPinHandler: ((CGFloat, CGFloat) -> Void )?
    
    @discardableResult
    func validationSuccessHandler(closure: @escaping ((Bool) -> Void)) -> Self {
        self.validationHandler = closure
        return self
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.oldPinField.textField.becomeFirstResponder()
        self.newPinField.textField.isUserInteractionEnabled = false
        self.confirmPinField.textField.isUserInteractionEnabled = false
        
        self.oldPinField
            .addTextRule { (text) -> TextRuleResult in
                var warningText = ""
                if text.isEmpty {
                    warningText = NSLocalizedString("Old pin should not be empty", comment: "A failure message telling the user that new pin should not be empty")
                } else if !text.isNumberFormat() || text.length != 4 {
                    warningText = NSLocalizedString("Old pin you have entered is incorrect", comment: "A failure message telling the user that new pin should not be empty")
                }
                return TextRuleResult(withConditionResult: warningText.length == 0 ,
                                      failedMessage: warningText)
        }
        
        self.newPinField
            .addTextRule { (text) -> TextRuleResult in
                var warningText = ""
                if text.isEmpty {
                    warningText = NSLocalizedString("New pin should not be empty", comment: "A failure message telling the user that new pin should not be empty")
                } else if !text.isNumberFormat() || text.length != 4 {
                    warningText = NSLocalizedString("New pin you have entered is incorrect", comment: "A failure message telling the user that new pin should not be empty")
                } else if text == self.oldPinField.textField.text {
                    warningText = NSLocalizedString("Old pin and New pin should not be same", comment: "A failure message telling the user that new pin should not be same with old pin")
                }
                return TextRuleResult(withConditionResult: warningText.length == 0 ,
                                      failedMessage: warningText)
        }
        
        self.confirmPinField
            .addTextRule { (text) -> TextRuleResult in
                var warningText = ""
                if text.isEmpty {
                    warningText = NSLocalizedString("Confirm pin should not be empty", comment: "A failure message telling the user that new pin should not be empty")
                } else if !text.isNumberFormat() {
                    warningText = NSLocalizedString("Confirm pin you have entered is incorrect", comment: "A failure message telling the user that confirm pin should not be empty")
                } else if text != self.newPinField.textField.text {
                    warningText = NSLocalizedString("Confirm pin and New pin should be same", comment: "A failure message telling the user that confirm pin should be same with new pin")
                }
                return TextRuleResult(withConditionResult: warningText.length == 0 ,
                                      failedMessage: warningText)
        }
        
        assignCommonProp(field: oldPinField, prevRes: nil, nextRes: nil)
        assignCommonProp(field: newPinField, prevRes: oldPinField, nextRes: nil)
        assignCommonProp(field: confirmPinField, prevRes: newPinField, nextRes: nil)
    }
    
    @objc func editingChangeAction(_ textField: UITextField) {
        guard let handler = validationHandler else {
            return
        }
        if self.oldPinField.satisfiesAllTextRules() && self.newPinField.satisfiesAllTextRules() && self.confirmPinField.satisfiesAllTextRules() {
            handler(true)
        } else {
            handler(false)
        }
    }
    
    private func assignCommonProp(field: DesignableTFView, prevRes: DesignableTFView?, nextRes: DesignableTFView?) {
        let font = FontBook.Regular.ofTitleSize()
        let minFontSize: CGFloat = 10.0
        
        field
            .set(TFkeyboardType: .numberPad)
            .setToolbar(prevResponder: prevRes, nextResponder: nextRes)
            .set(secureTextEntry: true)
            .set(TFFont: font, minFontSize: minFontSize)
            .set(addLineBorder: .lightGray)
            .set(TFkeyboardReturnType: (field == confirmPinField) ? .done : .next)
            .textField.delegate = self
        
        field.textField.addTarget(self, action: #selector(editingChangeAction(_:)), for: .editingChanged)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func getPin() -> (String, String) {
        return (self.oldPinField.textField.text ?? "", self.newPinField.textField.text ?? "")
    }
    
    deinit {
        print("Deint - ChangePinTVcell")
    }
    
}

extension ChangePinTVcell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case oldPinField.textField:
            newPinField.textField.becomeFirstResponder()
        case newPinField.textField:
            confirmPinField.textField.becomeFirstResponder()
        case confirmPinField.textField:
            confirmPinField.textField.resignFirstResponder()
        default:
            break
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        getSelectedField(textField: textField, isBegin: true).clearInlineError()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        oldPinField.clearInlineError()
        newPinField.clearInlineError()
        confirmPinField.clearInlineError()
        
        oldPinField.set(addLineBorder: .lightGray)
        newPinField.set(addLineBorder: .lightGray)
        confirmPinField.set(addLineBorder: .lightGray)
        
        if let text = oldPinField.textField.text, text.isNotEmpty() {
            oldPinField.applyAllTextRules()
        }
        
        if newPinField.textField.isUserInteractionEnabled, let text = newPinField.textField.text, text.isNotEmpty() {
            newPinField.applyAllTextRules()
        }
        
        if confirmPinField.textField.isUserInteractionEnabled, let text = confirmPinField.textField.text, text.isNotEmpty() {
            confirmPinField.applyAllTextRules()
        }
        
        warningHandler?()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else {
            return true
        }
        
        if !string.allowNumbersOnly() {
            return false
        }
        
        let newLength = text.count + string.count - range.length
        if textField == oldPinField.textField {
            if newLength < 4 {
                self.newPinField.textField.isUserInteractionEnabled = false
                if newLength == 3 {
                    self.oldPinField.setToolbar(prevResponder: nil, nextResponder: nil)
                    self.oldPinField.textField.reloadInputViews()
                }
            } else {
                self.oldPinField.setToolbar(prevResponder: nil, nextResponder: self.newPinField)
                self.oldPinField.textField.reloadInputViews()
                self.newPinField.textField.isUserInteractionEnabled = true
            }
            
        } else if textField == newPinField.textField {
            if newLength < 4 {
                newPinField.clearInlineError()
                confirmPinField.textField.text = ""
                confirmPinField.clearInlineError()
                confirmPinField.set(addLineBorder: .lightGray)
                self.confirmPinField.textField.isUserInteractionEnabled = false

                if newLength == 3 {
                    newPinField.setToolbar(prevResponder: oldPinField, nextResponder: nil)
                    self.newPinField.textField.reloadInputViews()
                }
                
            } else {
                let wholeText = "\(text)\(string)"
                if wholeText == oldPinField.textField.text {
                    newPinField.textField.insertText("\(string)")
                    newPinField.applyAllTextRules()
                    warningHandler?()
                    return false
                }
                newPinField.clearInlineError()
                newPinField.setToolbar(prevResponder: oldPinField, nextResponder: self.confirmPinField)
                self.newPinField.textField.reloadInputViews()
                self.confirmPinField.textField.isUserInteractionEnabled = true
            }
        }
        
        return newLength <= 4
    }
}

extension ChangePinTVcell {
    fileprivate func getSelectedField(textField: UITextField, isBegin: Bool) -> DesignableTFView {
        switch textField {
        case oldPinField.textField:
            if isBegin {
                oldPinHandler?(oldPinField.frame.origin.y, oldPinField.frame.height)
            }
            return oldPinField
        case newPinField.textField:
            if isBegin {
                newPinHandler?(newPinField.frame.origin.y, newPinField.frame.height)
            }
            return newPinField
        default:
            if isBegin {
                confirmPinHandler?(confirmPinField.frame.origin.y, confirmPinField.frame.height)
            }
            return confirmPinField
        }
    }
}
