//
//  DesignableTFView.swift
//  CellDynamicIncreaseDemo
//
//  Created by Mohsin Surani on 23/10/17.
//  Copyright © 2017 Mohsin Surani. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
final class DesignableTFView: UIView {
    
    var textField: UITextField!
    var textView: UITextView!
    var titleLable: UILabel!
    var warningLable: DesignableLabel!
    fileprivate var upperGapView: UIView!
    fileprivate var lineBorderView: UIView!
    var forgotPass: (() -> Void )?
    var textfieldDidChangeClosure: (() -> Void )?
    
    fileprivate var prevField: DesignableTFView?
    fileprivate var nextField: DesignableTFView?
    
    fileprivate var textRules = [((String) -> TextRuleResult)]()
    fileprivate var textViewText: String?

    var text: String {
         return  (textField.text == "" ? textViewText : textField.text) ?? ""
    }
    
    @IBInspectable open dynamic var hideTextField: Bool { // Title hide and show
        get { return self._hideTextField ?? false }
        set {
            self._hideTextField = newValue
            self.textField.isHidden = self._hideTextField ?? false
        }
    }
    fileprivate var _hideTextField: Bool?
    
    @IBInspectable open dynamic var hideTextView: Bool { // Title hide and show
        get { return self._hideTextView ?? false }
        set {
            self._hideTextView = newValue
            self.textView.isHidden = self._hideTextView ?? false
        }
    }
    fileprivate var _hideTextView: Bool?
    
    @IBInspectable open dynamic var hideBorderView: Bool { // Title hide and show
        get { return self._hideBorderView ?? false }
        set {
            self._hideBorderView = newValue
            self.lineBorderView.isHidden = self._hideBorderView ?? false
        }
    }
    fileprivate var _hideBorderView: Bool?
    
    @IBInspectable open dynamic var upperGap: CGFloat { // Gap between Title and textfield
        get { return self._upperGap ?? 0 }
        set {
            self._upperGap = newValue
            self.upperGapView.heightAnchor.constraint(equalToConstant: self._upperGap ?? 0).isActive = true
            self.upperGapView.isHidden = false
        }
    }
    fileprivate var _upperGap: CGFloat?
    
    @IBInspectable open dynamic var titleFontSize: CGFloat { // title font size
        get { return self._titleFontSize ?? 0 }
        set {
            self._titleFontSize = newValue
            self.titleLable.font = UIFont.systemFont(ofSize: _titleFontSize ?? 0)
        }
    }
    fileprivate var _titleFontSize: CGFloat?
    
    @IBInspectable open dynamic var title: String { // TitleLabel: text
        get { return self._title ?? "" }
        set {
            self._title = newValue
            self.titleLable.text = _title ?? ""
            self.titleLable.isHidden = _title?.length == 0
        }
    }
    fileprivate var _title: String?
    
    @IBInspectable open dynamic var warningInfo: String { // set warning text
        get { return self._warningInfo ?? "" }
        set {
            self._warningInfo = newValue
            self.warningLable.text = _warningInfo ?? ""
            self.warningLable.isHidden = _warningInfo?.length == 0
        }
    }
    fileprivate var _warningInfo: String?
    
    @IBInspectable open dynamic var warningFontSize: CGFloat { // set warning font size
        get { return self._warningFontSize ?? 0 }
        set {
            self._warningFontSize = newValue
            self.warningLable.font = UIFont.systemFont(ofSize: _warningFontSize ?? 0)
        }
    }
    fileprivate var _warningFontSize: CGFloat?
    
    @IBInspectable var warningTextColor: UIColor? { // set textview text color
        get {
            return self._warningTextColor
        }
        set {
            self._warningTextColor = newValue
            self.warningLable.textColor = _warningTextColor ?? .clear
        }
    }
    fileprivate var _warningTextColor: UIColor?
    
    @IBInspectable open dynamic var descFontSize: CGFloat { // set warning font size
        get { return self._descFontSize ?? 0 }
        set {
            self._descFontSize = newValue
            self.textView.font = UIFont.systemFont(ofSize: _descFontSize ?? 0)
        }
    }
    fileprivate var _descFontSize: CGFloat?
    
    @IBInspectable open dynamic var inputHeight: CGFloat { // set textfield height
        get { return self._inputHeight ?? 0 }
        set {
            self._inputHeight = newValue
            if textField.isHidden == false {
                self.textField.heightAnchor.constraint(equalToConstant: _inputHeight ?? 0).isActive = true
            } else {
                self.textView.heightAnchor.constraint(equalToConstant: _inputHeight ?? 0).isActive = true
            }
        }
    }
    fileprivate var _inputHeight: CGFloat?
    
    @IBInspectable var titleTextColor: UIColor? { // set titleLabel text color
        get {
            return self._titleTextColor
        }
        set {
            self._titleTextColor = newValue
            self.titleLable.textColor = _titleTextColor ?? .clear
        }
    }
    fileprivate var _titleTextColor: UIColor?
    
    @IBInspectable var cornerRadius: CGFloat = 0 { // set textfield corner radius
        didSet {
            textField.layer.cornerRadius = cornerRadius
            self.textView.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0 {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var rightPadding: CGFloat = 0 {
        didSet {
            updateView()
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
                self.textView.layer.borderWidth = borderWidth
                self.textField.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear { //border color for textfield and line
        didSet {
            self.textField.layer.borderColor = borderColor.cgColor
            self.textView.layer.borderColor = borderColor.cgColor
            self.lineBorderView.backgroundColor = borderColor
        }
    }
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self._placeHolderColor
        }
        set {
            self._placeHolderColor = newValue
           setPlaceHolderColor()
        }
    }
    fileprivate var _placeHolderColor: UIColor?
    
    @IBInspectable var inputTextColor: UIColor? {
        get {
            return self._inputTextColor
        }
        set {
            self._inputTextColor = newValue
            self.textField.textColor = _inputTextColor ?? .clear
            self.textView.textColor = _inputTextColor ?? .clear
        }
    }
    fileprivate var _inputTextColor: UIColor?
    
    @IBInspectable var placeHolderText: String? {
        get {
            return self._placeHolderText
        }
        set {
            self._placeHolderText = newValue
            self.textField.placeholder = _placeHolderText ?? ""
            setPlaceHolderColor()
        }
    }
    fileprivate var _placeHolderText: String?

    @IBInspectable var rightImage: UIImage? {
        didSet {
            updateView()
        }
    }
    @IBInspectable var buttonTitleColor: UIColor? {
        didSet {
            updateView()
        }
    }
    @IBInspectable var buttonTitle: String? {
        get {
            return self._buttonTitle
        }
        set {
            self._buttonTitle = newValue
            updateView()
        }
    }
    fileprivate var _buttonTitle: String?
    
    @IBInspectable var buttonTitleFontSize: CGFloat = 10 {
        didSet {
            updateView()
        }
    }
    var isRightViewEnabled: Bool {
        get {
            return self._isRightViewEnabled
        }
        set {
            self._isRightViewEnabled = newValue
            updateRightView(withEnable: _isRightViewEnabled)
        }
    }
    fileprivate var _isRightViewEnabled: Bool = true
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        baseInit()
    }
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        baseInit()
    }
    public init() {
        super.init(frame: CGRect.zero)
        baseInit()
    }
    override open func layoutSubviews() {
        super.layoutSubviews()
    }
}
extension DesignableTFView {
    private func updateView() {
        self.textField.layer.masksToBounds = true
        updateRightView(withEnable: _isRightViewEnabled)
        updateLeftView()
    }
    fileprivate func baseInit() {
        self.titleLable = UILabel()
        self.titleLable.numberOfLines = 0
        
        self.upperGapView = UIView()
        self.upperGapView.backgroundColor = .clear
        
        self.warningLable = DesignableLabel()
        self.warningLable.textColor = .red
        self.warningLable.topInset = 3
        self.warningLable.numberOfLines = 0
        
        self.textField = UITextField()
        
        self.textView = UITextView()
        
        self.lineBorderView = UIView()
        self.lineBorderView.backgroundColor = ColorConstant.grayLineBorderProfile
        
        let stackView = UIStackView()
        stackView.axis = UILayoutConstraintAxis.vertical
        stackView.distribution = UIStackViewDistribution.fill
        stackView.alignment = UIStackViewAlignment.fill
        stackView.spacing = 1.0
        stackView.addArrangedSubview(self.titleLable)
        stackView.addArrangedSubview(self.upperGapView)
        stackView.addArrangedSubview(self.textField)
        stackView.addArrangedSubview(self.textView)
        stackView.addArrangedSubview(self.lineBorderView)
        stackView.addArrangedSubview(self.warningLable)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        
        stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
        self.lineBorderView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        self.titleLable.isHidden = true
        self.warningLable.isHidden = true
        self.lineBorderView.isHidden = true
        self.upperGapView.isHidden = true
        
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let closure = textfieldDidChangeClosure {
            closure()
        }
    }
}

// MARK: Textfield updating left and right view

extension DesignableTFView {
    func updateLeftView() {
        textField.leftViewMode = .always
        let imageView = UIImageView(frame: CGRect(x: leftPadding, y: 0, width: 20, height: 20))
        var width = leftPadding
        
        if let image = self.leftImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            width = leftPadding + 20 + 10
        }
        
        if textField.borderStyle == .none || textField.borderStyle == .line {
            width += 5
        }
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 20))
        view.addSubview(imageView)
        textField.leftView = view
    }
    
    func updateRightView(withEnable isEnable: Bool) {
        if (rightImage != nil) || (_buttonTitle != nil) {
            textField.rightViewMode = .always
            let button = UIButton(type: .custom)
            let width = rightPadding + 10
            button.frame = CGRect(x: 0, y: 0, width: width, height: 30)
            
            button.backgroundColor = .clear
            button.setTitleColor(buttonTitleColor, for: .normal)
            if _buttonTitle?.lowercased() == "update" {
                button.setAttributedTitle(NSAttributedString.getUnderLineText(string: _buttonTitle ?? "", color: ColorConstant.buttonBackgroundColorPink), for: .normal)
            } else {
                button.setTitle(_buttonTitle, for: .normal)
            }
            button.setImage(rightImage, for: .normal)
            button.titleLabel?.font = FontBook.Regular.of(size: 12)
            button.addTarget(self, action: #selector(forgotPasswordClicked), for: .touchUpInside)
            let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 30))
            view.addSubview(button)
            button.isEnabled(state: isEnable)
            textField.rightView = view
        }
    }
    
    @objc private func forgotPasswordClicked() {
        forgotPass?()
    }
}

// MARK: Textfield properties assign..

extension DesignableTFView {
    
    @discardableResult
    func set(TFkeyboardReturnType: UIReturnKeyType) -> Self {
        self.textField.returnKeyType = TFkeyboardReturnType
        return self
    }
    
    @discardableResult
    func set(TFkeyboardType: UIKeyboardType) -> Self {
        self.textField.keyboardType = TFkeyboardType
        return self
    }
    
    @discardableResult
    func set(textAlignment: NSTextAlignment) -> Self {
        self.textField.textAlignment = textAlignment
        return self
    }
    
    @discardableResult
    func set(secureTextEntry: Bool) -> Self {
        self.textField.isSecureTextEntry = secureTextEntry
        return self
    }
    
    @discardableResult
    func set(autoCapital: UITextAutocapitalizationType) -> Self {
        self.textField.autocapitalizationType = autoCapital
        return self
    }
    
    @discardableResult
    func set(clearHideWhileTyping: UITextFieldViewMode) -> Self {
        self.textField.clearButtonMode = clearHideWhileTyping
        return self
    }
    
    @discardableResult
    func set(TFFont: UIFont, minFontSize: CGFloat) -> Self {
        self.textField.font = TFFont
        self.textField.minimumFontSize = minFontSize
        self.textField.adjustsFontSizeToFitWidth = true
        return self
    }
    
    @discardableResult
    func set(addLineBorder color: UIColor) -> Self {
     
        self.lineBorderView.isHidden = false
        self.lineBorderView.backgroundColor = color
        return self
    }
    
    // MARK: TextView properties assign..
    @discardableResult
    func set(TVFont: UIFont) -> Self {
        self.textView.font = TVFont
        return self
    }
    
    @discardableResult
    func set(textViewPlaceHolder: String) -> Self {
        self.textView.text = textViewPlaceHolder
        return self
    }
    
    @discardableResult
    func set(paddingAllAround: CGFloat) -> Self {
        self.textView.textContainerInset = UIEdgeInsets(top: paddingAllAround, left: paddingAllAround, bottom: paddingAllAround, right: paddingAllAround)
        return self
    }
    
    // MARK: Warning properties assign..
    @discardableResult
    func set(warningFont: UIFont) -> Self {
        self.warningLable.font = warningFont
        return self
    }
    
    // MARK: TitleLabel properties assign..
    @discardableResult
    func set(titleFont: UIFont) -> Self {
        self.titleLable.font = titleFont
        return self
    }
    
    // Textview Text
    @discardableResult
    func set(textViewText: String) -> Self {
        self.textViewText = textViewText
        self.textView.text = textViewText
        return self
    }
}

// MARK: Textfield validation rules code..
extension DesignableTFView {
    @discardableResult
    func textfiledDidChange(change: @escaping () -> Void) -> Self {
        textfieldDidChangeClosure = change
        return self
    }
    
    @discardableResult
    func addTextRule(_ rule: @escaping ((String) -> TextRuleResult)) -> Self {
        textRules.append(rule)
        return self
    }
    
    func applyAllTextRules() {
        for rule in textRules {
            let textRuleResult = rule(text)
            if textRuleResult.conditionResult == false {
                displayInlineError(errorDescription: textRuleResult.failedMessage)
                break
            }
        }
    }
    
    func applyAllTextViewRules() {
        for rule in textRules {
            let textRuleResult = rule(self.textView.text ?? "")
            if textRuleResult.conditionResult == false {
                displayInlineError(errorDescription: textRuleResult.failedMessage)
                break
            }
        }
    }
    
    func satisfiesTextViewTextRules() -> Bool {
        var result = false
        for rule in textRules {
            let textRuleResult = rule(textViewText ?? "")
            result = textRuleResult.conditionResult
            break
        }
        return result
    }
    
    func satisfiesAllTextRules() -> Bool {
        return textRules.reduce(true) { (accumulatedResult, rule) -> Bool in
            let textRuleResult = rule(text)
            return accumulatedResult && textRuleResult.conditionResult
        }
    }
    
    func displayInlineError(errorDescription: String) {
        self.warningInfo = errorDescription
        if self.lineBorderView.isHidden == false {
            self.lineBorderView.backgroundColor = ColorConstant.shopNowButtonBGColor
        } else {
            textField.layer.borderColor = ColorConstant.shopNowButtonBGColor.cgColor
            textView.layer.borderColor = ColorConstant.shopNowButtonBGColor.cgColor
        }
    }
    
    func clearInlineError() {
        self.warningInfo = ""
        if self.lineBorderView.isHidden == false {
            self.lineBorderView.backgroundColor = ColorConstant.shopNowButtonBGColor
        } else {
            textField.layer.borderColor = UIColor.lightGray.cgColor
            textView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
}

// MARK: Toolbar added for each textfield

extension DesignableTFView {
    //adding toolbar
    @discardableResult
    func setToolbar(prevResponder: DesignableTFView?, nextResponder: DesignableTFView?) -> Self {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        if prevResponder == nil && nextResponder == nil {
            toolBar.setItems([spaceButton, doneButton], animated: false)
        } else {
            let previousButton = UIBarButtonItem(image: #imageLiteral(resourceName: "uparrow"), style: .plain, target: self, action: #selector(previousPressed))
            let nextButton = UIBarButtonItem(image: #imageLiteral(resourceName: "dropdownArrow"), style: .plain, target: self, action: #selector(nextPressed))
            toolBar.setItems([previousButton, nextButton, spaceButton, doneButton], animated: false)
            
            previousButton.isEnabled = prevResponder != nil
            nextButton.isEnabled = nextResponder != nil
            
            prevField = prevResponder
            nextField = nextResponder
        }
        
        if self.textField.isHidden == false {
            self.textField.inputAccessoryView = toolBar
        } else {
            self.textView.inputAccessoryView = toolBar
        }
        
        return self
    }
    
    @objc func donePressed() {
        self.endEditing(false)
    }
    
    @objc func previousPressed() {
        if prevField?.textField.isHidden == false {
            self.prevField?.textField.becomeFirstResponder()
        } else {
            prevField?.textView.becomeFirstResponder()
        }
    }
    
    @objc func nextPressed() {
        if nextField?.textField.isHidden == false {
            nextField?.textField.becomeFirstResponder()
        } else {
            nextField?.textView.becomeFirstResponder()
        }
    }
    
    fileprivate func setPlaceHolderColor() {
        guard let placeHolderText = self.textField.placeholder else {
            return
        }
        self.textField.attributedPlaceholder = NSAttributedString(string: self.textField.placeholder != nil ? placeHolderText : "", attributes: [NSAttributedStringKey.foregroundColor: self._placeHolderColor ?? UIColor.gray])
    }
}

internal struct TextRuleResult {
    let conditionResult: Bool
    let failedMessage: String
    
    init(withConditionResult result: Bool, failedMessage: String = "") {
        self.conditionResult = result
        self.failedMessage = failedMessage
    }
}
