//
//  PasswordPopUp.swift
//  PaybackPopup
//
//  Created by Mohsin.Surani on 18/08/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit
class PasswordPopUp: UIView, UIGestureRecognizerDelegate, UITextViewDelegate {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak fileprivate var titleLabel: UILabel!
    @IBOutlet weak fileprivate var InstructionTextView: UITextView!
    @IBOutlet weak fileprivate var PinGenerateButton: UIButton!
    @IBOutlet weak private var CloseButton: UIButton!
    @IBOutlet weak fileprivate var passWordView: UIView!
    @IBOutlet weak fileprivate var customView: DesignableTFView!
    @IBOutlet weak fileprivate var dobView: DesignableTFView!
    @IBOutlet weak fileprivate var dobViewHeightConstraint: NSLayoutConstraint!
    fileprivate var datePickerView: UIDatePicker!
    fileprivate var toolBar: UIToolbar!
    
    fileprivate var configuration = PopUpConfiguration()
    
    var generateOTPHandler: ((String, String) -> Void)?
    var linkActionHandler: (() -> Void)?
   
    typealias ValuesTuple = (title: String, Description: String, otpCode: String, pinString: String, InstructionString: NSAttributedString, otpPlaceHolder: String, errorMessage: String, textFieldText: String)

    override func layoutSubviews() {
        super.layoutSubviews()
        
        customView.widthAnchor.constraint(equalToConstant: 350).isActive = true
        customView.textField.attributedPlaceholder = NSAttributedString(string: customView.textField.placeholder ?? "", attributes: [NSAttributedStringKey.foregroundColor: UIColor.black])
        dobView.textField.attributedPlaceholder = NSAttributedString(string: dobView.textField.placeholder ?? "", attributes: [NSAttributedStringKey.foregroundColor: UIColor.black])
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setPropertiesForCustomView()
        setFontsColors()
    }
    
    private func setFontsColors() {
        messageLabel.font = FontBook.Black.of(size: 13)
        messageLabel.isHidden = true
        titleLabel.font = FontBook.Black.of(size: 16)
        PinGenerateButton.titleLabel?.font = FontBook.Regular.of(size: 15)
    }
    
    private func setPropertiesForCustomView() {
        
        let font = FontBook.Regular.of(size: 12)
        let minFontSize: CGFloat = 9.0
        
        dobView
            .set(TFFont: font, minFontSize: minFontSize)
            .set(warningFont: FontBook.Italic.ofSubTitleSize())
            .textField.delegate = self
        dobView.forgotPass = { [weak self] in
            self?.openDatePicker()
        }
        customView
            .setToolbar(prevResponder: nil, nextResponder: nil)
            .set(TFkeyboardType: .numberPad)
            .set(TFFont: font, minFontSize: minFontSize)
            .set(warningFont: FontBook.Italic.ofSubTitleSize())
            .textField.delegate = self
        
        customView.titleLable.textAlignment = .center
        customView.textField.addTarget(self, action: .editingChangeActionForPasswordPopUp, for: .editingChanged)
        PinGenerateButton.isEnabled(state: false)
    }
    
    @objc func openKeyboard() {
        customView.textField.becomeFirstResponder()
    }
    
    func initWithConfiguration(configuration: PopUpConfiguration) {
        self.configuration = configuration
        customView.warningInfo = ""
        setMessageLabel(isHidden: configuration.isMessageDisplay)
        customView.addTextRule { (text) -> TextRuleResult in
            return TextRuleResult(withConditionResult: text.count == configuration.textRules.length && text.isNumberFormat(), failedMessage: configuration.textRules.message)
        }
        let tuple = (title: configuration.titlePasswordString, Description: configuration.descriptionPasswordString, otpCode: configuration.otpString, pinString: configuration.pinGenerateString, InstructionString: configuration.instructionPasswordString, otpPlaceHolder: configuration.otpPlaceholderString, errorMessage: configuration.errorMessage, textFieldText: configuration.textFieldText)
        setAllValues(values: tuple)
        
        setAllColors(titleBackgroundColor: configuration.titlePasswordBackGroundColor, PinGenerateButtonBackColor: configuration.pinBackColor, popUpBackColor: configuration.popPasswordBackgroundColor, textFieldBorderColor: configuration.textFieldBorderColor)
        
        setHideShowUI(hideInstruction: configuration.hidePaswordInstruction, hideClose: configuration.hideClosePasswordPopUp, hideDescriptionPassword: configuration.hideDescriptionPassword, needAttributeAction: configuration.needAttributeAction, displayDOBView: configuration.isDOBViewDisplay)
        
        addGesture()
        addTextViewGesture()
        if customView.satisfiesAllTextRules() {
            PinGenerateButton.isEnabled(state: customView.satisfiesAllTextRules())
            return
        } else {
            PinGenerateButton.isEnabled(state: false)
        }
        //openKeyboard()
    }
    private func setAllValues(values: ValuesTuple ) {
        customView.warningInfo = values.errorMessage
        titleLabel.text = values.title
        customView.title = values.Description
        customView.textField.text = values.otpCode
        PinGenerateButton.setTitle(values.pinString, for: .normal)
        InstructionTextView.attributedText = values.InstructionString
        InstructionTextView.font = FontBook.Regular.of(size: 15)
        customView.textField.placeholder = values.otpPlaceHolder
        customView.textField.text = values.textFieldText
        dobView.textField.placeholder = "Enter Date of Birth"
    }
    
   private func setAllColors(titleBackgroundColor: UIColor, PinGenerateButtonBackColor: UIColor, popUpBackColor: UIColor, textFieldBorderColor: UIColor) {
        
        PinGenerateButton.backgroundColor = PinGenerateButtonBackColor
        titleLabel.backgroundColor = titleBackgroundColor
        passWordView.backgroundColor = popUpBackColor
        customView.textField.layer.borderColor = textFieldBorderColor.cgColor
    }
    
    private func setHideShowUI(hideInstruction: Bool, hideClose: Bool, hideDescriptionPassword: Bool, needAttributeAction: Bool, displayDOBView: Bool) {
        
        InstructionTextView.isHidden = hideInstruction
        CloseButton.isHidden = hideClose
        customView.titleLable.isHidden = hideDescriptionPassword
        
        self.dobViewHeightConstraint.constant = displayDOBView ? 50 : 0
        
    }
    
   private func addGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: .tapGestureActionForPasswordPopUp)
        tapGesture.numberOfTapsRequired = 1
        tapGesture.delegate = self
        self.addGestureRecognizer(tapGesture)
    }
    
   private func addTextViewGesture() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: .tappedTextViewForPasswordPopUp)
        InstructionTextView.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func tappedTextView(tapGesture: UIGestureRecognizer) {
        guard let textView = tapGesture.view as? UITextView else {
            return
        }
        let tapLocation = tapGesture.location(in: textView)
        if let textPosition = textView.closestPosition(to: tapLocation), let attr = textView.textStyling(at: textPosition, in: .forward), attr["NSLink"] != nil {
            customView.clearInlineError()
            self.linkActionHandler?()
        }
    }
    func updateDOBErrorMessage(errorMessage: String, textColor: UIColor = .red) {
        dobView.warningInfo = errorMessage
        dobView.warningTextColor = textColor
        self.dobViewHeightConstraint.constant = self.configuration.isDOBViewDisplay ? errorMessage.length > 0 ? 65 : 50 : 0
    }
    func updateErrorMessage(errorMessage: String, textColor: UIColor = .red) {
        customView.warningInfo = errorMessage
        customView.warningTextColor = textColor
    }
    
    @objc func tapGestureAction(sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
    
    @IBAction func generateOtpAction(_ sender: Any) {

        if let otpText = customView.textField.text {
            if customView.satisfiesAllTextRules() {
                self.generateOTPHandler?(otpText, dobView.textField.text ?? "")
            }
        }
    }
    @IBAction func closePopup(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    deinit {
        print(" PasswordPopUp deinit called")
    }
}
extension PasswordPopUp: UIPopoverPresentationControllerDelegate {
    fileprivate func openDatePicker() {
        self.customView.textField.resignFirstResponder()
        guard datePickerView == nil else {
            return
        }
        toolBar = UIToolbar(frame:CGRect(x: 0, y: dobView.frame.origin.y + dobView.frame.size.height + 40, width: self.passWordView.frame.size.width, height: 44))
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done  ", style: .done, target: self, action: .doneClickForPasswordPopUp)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        self.passWordView.addSubview(toolBar)
        toolBar.isHidden = false
        
        datePickerView = UIDatePicker(frame:CGRect(x: 0, y: toolBar.frame.origin.y + toolBar.frame.size.height, width: self.passWordView.frame.size.width, height: PinGenerateButton.frame.origin.y - 5))
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.addTarget(self, action: .datePickerValueChangedForPasswordPopUp, for: UIControlEvents.valueChanged)
        datePickerView.maximumDate = Date()
        datePickerView.backgroundColor = .white
        self.passWordView.addSubview(datePickerView)
    }
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        setDateToField(date: sender.date)
    }
    @objc func doneClick() {
        setDateToField(date: datePickerView.date)
        datePickerView.removeFromSuperview()
        toolBar.removeFromSuperview()
        datePickerView = nil
        toolBar = nil
    }
    private func setDateToField(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        dobView.textField.text = dateFormatter.string(from: date)
        self.updateDOBErrorMessage(errorMessage: "")
    }
    
   private func setMessageLabel(isHidden: Bool) {
        messageLabel.isHidden = !isHidden
    }
}

extension PasswordPopUp: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return textField == self.dobView.textField ? false : true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {
            return true
        }
        let newLength = text.count + string.count - range.length
        if newLength <= 0 {
            customView.clearInlineError()
        }
        return string.allowNumbersOnly() && newLength <= configuration.textRules.length
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        customView.clearInlineError()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = customView.textField.text, text.isNotEmpty() {
            customView.warningInfo = ""
            customView.warningTextColor = .red
            customView.applyAllTextRules()
        }
    }
    
    @objc func editingChangeAction(_ textField: UITextField) {
        PinGenerateButton.isEnabled(state: customView.satisfiesAllTextRules())
    }
}
