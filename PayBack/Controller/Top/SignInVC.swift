//
//  SingInVC.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 9/3/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit
import ReachabilitySwift

class SignInVC: UITableViewController {
    typealias UpdateLoginStatusClosur = ((Bool) -> Void)
    typealias UpdatePopToRootViewClosur = ((Bool) -> Void)
    fileprivate var loginStatus: UpdateLoginStatusClosur = { _ in }
    fileprivate var popToRootVC: UpdatePopToRootViewClosur = { _ in }
    
    @discardableResult
    func updateLogedInStatus(status: @escaping UpdateLoginStatusClosur) -> Self {
        self.loginStatus = status
        return self
    }
    @discardableResult
    func updatePopToRootVC(closure: @escaping UpdatePopToRootViewClosur) -> Self {
        self.popToRootVC = closure
        return self
    }
    var shouldValidateTextFields: Bool = true
    
    @IBOutlet weak fileprivate var newUserLabel: UILabel!
    @IBOutlet weak fileprivate var signUpButton: UIButton!
    
    @IBOutlet weak fileprivate var skipButton: UIButton!
    @IBOutlet weak private var logoImageView: UIImageView!
    
    @IBOutlet weak fileprivate var cardNoField: DesignableTFView!
    @IBOutlet weak fileprivate var pinField: DesignableTFView!
    
    @IBOutlet weak fileprivate var signInButton: UIButton!
    @IBOutlet weak private var orLabel: UILabel!
    
    @IBOutlet weak private var fbLoginButton: UIButton!
    @IBOutlet weak private var gPlusLoginButton: UIButton!
    
    fileprivate lazy var accountAuthenticator: AccountAuthenticator = {
        return AccountAuthenticator()
    }()
    fileprivate let forgotPinNWController = GetNewPinNetworkController()
    fileprivate var popPassword: PasswordPopUp?
    fileprivate let config = PopUpConfiguration()
    fileprivate let signInFetcher = SignInFetcher()
    fileprivate var mobileNo = ""
    fileprivate var showDOBInForgotPINPopup = false
    
    fileprivate var signInModel: SignInModel.SignInContents? {
        didSet {
            guard let model = signInModel else {
                return
            }
            if let imagePath = model.signInImage {
                self.logoImageView.downloadImageFromUrl(urlString: imagePath)
            }
            if let text = model.signInText {
                self.signInButton.setTitle(text.uppercased(), for: .normal)
            }
            
            if let show = model.showDateOfBirth {
                self.showDOBInForgotPINPopup = show
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.keyboardDismissMode = .onDrag
        signInButton.isEnabled(state: false)
        skipButton.setAttributedTitle(.getUnderLineText(string: "skip", color: .black), for: .normal)
        signUpButton.setAttributedTitle(.getUnderLineText(string: "Sign up", color: .black), for: .normal)
        configureFields()
        configureForgotPinPopup()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.checkConnection() {
            self.fetchSignInUIDetails()

        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (indexPath.row == 0) ? ScreenSize.SCREEN_HEIGHT / 2.2 : UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    @IBAction func skipAction(_ sender: Any) {
        self.popToRootVC(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        self.popToRootVC(true)
        self.performSegue(withIdentifier: "toSignUp", sender: nil)
    }
    
    @IBAction func signInAction(_ sender: Any) {
        // alias will be either mobile no. or card number(always 16 character)
        // aliasType: 3 for mobile no. & 1 for card number
        // secretType: always will be 4
        
        let canSignIn = cardNoField.satisfiesAllTextRules() && pinField.satisfiesAllTextRules()
        
        guard canSignIn, let cardNo = cardNoField.textField.text, let pin = pinField.textField.text else {
            return
        }

        let lenth = cardNoField.textField.text?.length
        let aliasType = lenth == 10 ? StringConstant.aliasTypeMobileNumber : lenth == 16 ? StringConstant.aliasTypeCardNumber : "0"
        self.view.endEditing(false)
        self.startActivityIndicator()
        accountAuthenticator
            .onSuccess { [weak self] in
                print("Login Success")
                self?.stopActivityIndicator()
                self?.loginStatus(true)
                self?.dismiss(animated: true, completion: nil)
            }
            .onError { [weak self] (error) in
               self?.stopActivityIndicator()
                self?.showErrorView(errorMsg: error)
                self?.loginStatus(false)
            }
            .authenticate(alias: cardNo, aliasType: aliasType, secret: pin)
    }
    @IBAction func loginWithFb(_ sender: Any) {
    }
    
    @IBAction func loginWithGooglePlus(_ sender: Any) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print(" SignInVC deinit called")
    }
}
extension SignInVC {
    fileprivate func fetchSignInUIDetails() {
        signInFetcher
            .onSuccess { [weak self] (signInModel) in
                self?.signInModel = signInModel.signInContents
            }
            .onError { (error) in
                print("\(error)")
            }
            .fetch()
    }
}

extension SignInVC {
    fileprivate func generateOTP(_ mobileNo: String) {
        if mobileNo.length == 10 {
            guard let window = UIApplication.shared.keyWindow else {
                return
            }
            window.startActivityIndicator()
            forgotPinNWController
                .onError(error: { [weak self]( error ) in
                    print("generateOTP - \(error)")
                    window.stopActivityIndicator()
                    DispatchQueue.main.async {
                        self?.popPassword?.updateErrorMessage(errorMessage: error)
                    }
                })
                .onSuccess(success: { [weak self] ( successMsg ) in
                    print("generateOTP - \(successMsg)")
                    window.stopActivityIndicator()
                    self?.openGeneratePinOTP()
                    DispatchQueue.main.async {
                        self?.popPassword?.updateErrorMessage(errorMessage: successMsg, textColor: ColorConstant.myTranscationPointColorGreen)
                    }
                })
                .generateOTP(withMobileNo: mobileNo)
        }
    }
    fileprivate func forgotPIN(_ mobileNo: String, otp: String, dob: String ) {
        if mobileNo.length == 10 {
            if self.showDOBInForgotPINPopup, dob.trimmingCharacters(in: .whitespacesAndNewlines).isNotEmpty() {
                self.popPassword?.updateDOBErrorMessage(errorMessage: "Please enter DOB")
                return
            }
            guard let window = UIApplication.shared.keyWindow else {
                return
            }
            window.startActivityIndicator()
            forgotPinNWController
                .onError(error: { [weak self]( error ) in
                    print("forgotPIN - \(error)")
                    window.stopActivityIndicator()
                    DispatchQueue.main.async {
                        self?.popPassword?.updateErrorMessage(errorMessage: error)
                    }
                })
                .onSuccess(success: { [weak self] ( successMsg ) in
                    print("forgotPIN - \(successMsg)")
                    window.stopActivityIndicator()
                    self?.popPassword?.removeFromSuperview()
                    self?.openAlertPopForSuccess()
                })
                .getPIN(alias: mobileNo, otp: otp, dob: dob)
        }
    }
}
extension SignInVC {
    
    fileprivate func configureForgotPinPopup() {
        pinField.forgotPass = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.cardNoField.textField.resignFirstResponder()
            strongSelf.pinField.textField.resignFirstResponder()
            guard strongSelf.cardNoField.text.length <= 10 else {
                strongSelf.showErrorView(errorMsg: "Please enter valid mobile number")
                return
            }
            guard let window = UIApplication.shared.keyWindow else {
                return
            }
            strongSelf.popPassword = Bundle.main.loadNibNamed(passwordAlertID, owner: self, options: nil)?.first as? PasswordPopUp
            strongSelf.popPassword?.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)
            strongSelf.config
                .set(diplayDOB: false)
                .set(hideClosePasswordPopUp: false)
                .set(hidePasswordInstruction: true)
                .set(pinGenerateString: NSLocalizedString("GENERATE OTP", comment: "GENERATE OTP"))
                .set(otpPlaceholderString: NSLocalizedString("Enter Mobile number", comment: "Enter Mobile number"))
                .set(titlePasswordString: NSLocalizedString("FORGOT PIN", comment: "FORGOT PIN"))
                .set(descriptionPasswordString: NSLocalizedString("Forgot PIN? Generate new PIN", comment: "Forgot PIN? Generate new PIN"))
                .set(textFieldText: strongSelf.cardNoField.text.length > 10 ? "" : strongSelf.cardNoField.text)
                .textRule((length: 10, message: NSLocalizedString("The Mobile number you've entered is incorrect", comment: "A failure message telling the user that their date of birth needs not be empty")))
            
            strongSelf.popPassword?.initWithConfiguration(configuration: strongSelf.config)
            window.addSubview(strongSelf.popPassword!)
            self?.popPassword?.generateOTPHandler = { [weak self] (mobileNo, _) in
                self?.mobileNo = mobileNo
                self?.generateOTP(mobileNo)
            }
        }
    }
    
    fileprivate func openGeneratePinOTP() {
        self.config
            .set(diplayDOB: self.showDOBInForgotPINPopup)
            .set(hideClosePasswordPopUp: false)
            .set(hidePasswordInstruction: false)
            .set(pinGenerateString: NSLocalizedString("Generate PIN", comment: "VERIFY NOW"))
            .set(otpPlaceholderString: NSLocalizedString("Enter OTP here", comment: "Enter OTP here"))
            .set(titlePasswordString: NSLocalizedString("FORGOT PIN", comment: "FORGOT PIN"))
            .set(descriptionPasswordString: NSLocalizedString("OTP sent to your registered mobile number \(getMobileNum())", comment: "We have sent otp to your registered mobile number"))
            .set(instructionPasswordString: getAttributedTextForOtp())
            .set(textFieldText: "")
            .set(messageLabel: true)
            .textRule((length: 6, message: NSLocalizedString("OTP you have entered is incorrect", comment: "OTP you have entered is incorrect")))
        
        popPassword?.initWithConfiguration(configuration: config)
        popPassword?.generateOTPHandler = { [weak self] (otp, dob) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.forgotPIN(strongSelf.mobileNo, otp: otp, dob: dob)
        }
        popPassword?.linkActionHandler = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.generateOTP(strongSelf.mobileNo)
        }
    }
    
    private func getMobileNum() -> String {
        guard !self.mobileNo.isEmpty else {
            return ""
        }
        let str: NSString = self.mobileNo as NSString
        let length = str.length
        let startIndex = 2
        let lastIndex = length - 5
        
        let range = NSRange(location: startIndex, length: lastIndex)
        let str1 = str.replacingCharacters(in: range, with: String(repeating: "X", count: lastIndex))
        return str1
    }
    
    fileprivate func getAttributedTextForOtp() -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        let staticText = NSMutableAttributedString(string: NSLocalizedString("If you have not received otp, click here and we will resend it", comment: "otp"), attributes: [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont(name: "Arial", size: 18) as Any, NSAttributedStringKey.paragraphStyle: paragraph])
        
        let linkWasSet = self.setAsLink(attr: staticText, textToFind: "here", linkURL: "")
        
        return linkWasSet
    }
    fileprivate func setAsLink(attr: NSMutableAttributedString, textToFind: String, linkURL: String) -> NSMutableAttributedString {
        
        let foundRange = attr.mutableString.range(of: textToFind)
        
        if foundRange.location != NSNotFound {
            attr.addAttribute(NSAttributedStringKey.link, value: linkURL, range: foundRange)
            attr.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: foundRange)
            return attr
        }
        return attr
    }
    private func openAlertPopForSuccess() {
        guard let window = UIApplication.shared.keyWindow, let popUpView = Bundle.main.loadNibNamed(alertPopUpID, owner: self, options: nil)?.first as? AlertPopUp else {
            return
        }
        popUpView.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)
        window.addSubview(popUpView)
        
        let config = PopUpConfiguration()
            .set(hideConfirmButton: true)
            .set(hideOkButton: false)
            .set(hideCancelButton: true)
            .set(titleText: NSLocalizedString("SUCCESS", comment: "SUCCESS"))
            .set(desText: NSLocalizedString("Your new PIN has been successfully sent to your Linked Mobile Number", comment: "Your new PIN has been successfully sent to your Linked Mobile Number"))
        
        popUpView.initWithConfiguration(configuration: config)
        popUpView.OkActionHandler = {
            self.popPassword?.removeFromSuperview()
        }
    }
}

extension SignInVC {
    fileprivate func configureFields() {
        // 9902068827 - 1467 - Harish
        // 8050868766 - 1686 - rakes
        /* TODO: removed before going live */
//        cardNoField.textField.text = "9066522490"
//        pinField.textField.text = "8575"
//        signInButton.isEnabled(state: true)
        /* ----------------------------*/
        pinField.warningInfo = ""
        cardNoField.warningInfo = ""
        
        cardNoField
            .set(TFkeyboardReturnType: .next)
            .setToolbar(prevResponder: nil, nextResponder: pinField)
            .addTextRule { (text) -> TextRuleResult in
                return TextRuleResult(withConditionResult: text.isNotEmpty() && text.isNumberFormat() && (text.count == 10 || text.count == 16) ,
                                      failedMessage: NSLocalizedString("The Card Number / Mobile Number you have entered is incorrect", comment: "A failure message telling the user that their card/mobile number needs to be equal of 10/16 characters"))
            }
        
        pinField
            .set(TFkeyboardReturnType: .done)
            .setToolbar(prevResponder: cardNoField, nextResponder: nil)
            .set(secureTextEntry: true)
            .addTextRule { (text) -> TextRuleResult in
                return TextRuleResult(withConditionResult: text.isNotEmpty() && text.isNumberFormat() && text.count == 4,
                                      failedMessage: NSLocalizedString("The PIN you have entered is incorrect", comment: "A failure message telling the user that their PIN needs to be a minimum of 4 characters"))
            }
        
        self.setCommonProperties(field: cardNoField)
        self.setCommonProperties(field: pinField)
        setFonts()
    }
    
    private func setCommonProperties(field: DesignableTFView) {
        let font = FontBook.Regular.ofTitleSize()
        let minFontSize: CGFloat = 10.0
        
        field
            .set(TFkeyboardType: .numberPad)
            .set(TFFont: font, minFontSize: minFontSize)
            .set(warningFont: FontBook.Italic.ofSubTitleSize())
            .textField.delegate = self

        field.textField.addTarget(self, action: #selector(editingChangeAction(_:)), for: .editingChanged)
        field.warningLable.leftInset = 15
        field.warningLable.rightInset = 15
    }
    
    private func setFonts() {
        self.newUserLabel.font = FontBook.Regular.ofSubTitleSize()
        self.signUpButton.titleLabel?.font = FontBook.Regular.ofSubTitleSize()
        self.skipButton.titleLabel?.font = self.signUpButton.titleLabel?.font
        self.signInButton.titleLabel?.font = FontBook.Regular.ofTitleSize()
    }
}

extension SignInVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if cardNoField.textField == textField {
            cardNoField.clearInlineError()
        } else if pinField.textField == textField {
            pinField.clearInlineError()
        }
        self.tableView.updateTableView(animation: false)
        return true
    }
    
    @objc func editingChangeAction(_ textField: UITextField) {
        signInButton.isEnabled(state: cardNoField.satisfiesAllTextRules() && pinField.satisfiesAllTextRules())
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if shouldValidateTextFields, let text = textField.text, text.isNotEmpty() {
            if cardNoField.textField == textField {
                cardNoField.applyAllTextRules()
            } else if pinField.textField == textField {
                pinField.applyAllTextRules()
            }
            self.tableView.updateTableView(animation: false)
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else {
            return true
        }
        
        if !string.allowNumbersOnly() {
            return false
        }
        
        let newLength = text.count + string.count - range.length
        return newLength <= ((textField == self.pinField.textField) ? 4 : 16)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.cardNoField.textField {
            self.pinField.textField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
extension SignInVC {
    func checkConnection(withErrorViewYPosition position: CGFloat = 64) -> Bool {
        if let isReachable = Reachability()?.isReachable, isReachable == true {
            return isReachable
        }
        openConnectionErrorVC(position: position)
        return (Reachability()?.isReachable)!
    }
    func openConnectionErrorVC(position: CGFloat) {
        //if !self.checkConnection() {
        DispatchQueue.main.async { [weak self] in
            if let strongSelf = self, let connectionView = Bundle.main.loadNibNamed("ConnectionErrorView", owner: strongSelf, options: nil)?.first as? ConnectionErrorView {
                if #available(iOS 11.0, *) {
                    connectionView.frame = CGRect(x: 0, y: -20, width: strongSelf.view.frame.width, height: strongSelf.view.frame.height)
                } else {
                    connectionView.frame = CGRect(x: 0, y: position, width: strongSelf.view.frame.width, height: strongSelf.view.frame.height)
                }
                strongSelf.view.addSubview(connectionView)
                connectionView.connectionSuccess = { [weak self] in
                    self?.fetchSignInUIDetails()
                    connectionView.removeFromSuperview()
                }
            }
        }
        // }
    }
}
