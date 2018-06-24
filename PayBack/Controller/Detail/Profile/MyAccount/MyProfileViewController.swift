//
//  MyProfileViewController.swift
//  PayBack
//
//  Created by Dinakaran M on 04/10/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit
import CoreLocation

class MyProfileViewController: UITableViewController {
    fileprivate var isEditEnabled = false
    var updateMember = UpdateMemberNWController()
    
    typealias EditProfileUpdateClosure = ((Bool) -> Void)
    typealias InvalidTokenUpdateClosure = ((String) -> Void)
    var updateUserEditProfile: EditProfileUpdateClosure = { _ in }
    var updateInvalidToken: InvalidTokenUpdateClosure = { _ in }
    var editProfileSavePopupActionClosure: EditProfileUpdateClosure = { _ in }
    fileprivate var userAddressDataSource = [AddressSplitCellModel]()
    var editAddressModel: AddressSplitCellModel?
    
    fileprivate var popPassword: PasswordPopUp?
    fileprivate var mobileNo = ""
    fileprivate let config = PopUpConfiguration()
    
    @IBOutlet weak private var addressbutton: UIButton!
    @IBOutlet weak fileprivate var changePin: UIButton!
    @IBOutlet weak fileprivate var fNameField: DesignableTFView!
    @IBOutlet weak fileprivate var lNameField: DesignableTFView!
    @IBOutlet weak fileprivate var emailField: DesignableTFView!
    @IBOutlet weak fileprivate var mobileField: DesignableTFView!
    @IBOutlet weak fileprivate var addressField: DesignableTFView!
    @IBOutlet weak fileprivate var pincodeField: DesignableTFView!
    @IBOutlet weak fileprivate var dobField: DesignableTFView!
    
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.backgroundColor = .white
        picker.addTarget(self, action: #selector(self.handleDatePicker), for: .valueChanged)
        
        let gregorian: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let currentDate: Date = Date()
        var components: DateComponents = DateComponents()
        components.year = -19
        let maxDate: Date = gregorian.date(byAdding: components, to: currentDate, options: NSCalendar.Options(rawValue: 0))!
        components.year = -150
        let minDate: Date = gregorian.date(byAdding: components, to: currentDate, options: NSCalendar.Options(rawValue: 0))!
        picker.minimumDate = minDate
        picker.maximumDate = maxDate
        return picker
    }()
    
    fileprivate var cellHeights = [IndexPath: CGFloat]()
    fileprivate let addressPlaceHolderText = "Address"
    lazy var editButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH, height: 50))
        button.backgroundColor = ColorConstant.buttonBackgroundColorPink
        button.setTitle("EDIT PROFILE", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = FontBook.Regular.of(size: 17.0)
        button.addTarget(self, action: #selector(handleToggleEditBT), for: .touchUpInside)
        return button
    }()
    
    lazy var updateView: UIView = {
        var y = ScreenSize.SCREEN_HEIGHT - 49
        var height: CGFloat = 49
        if DeviceType.IS_IPHONEX {
            y = ScreenSize.SCREEN_HEIGHT - 49 - 32
            height = 49 + 32
        }
        let view = UIView(frame: CGRect(x: 0, y: y, width: ScreenSize.SCREEN_WIDTH, height: height))
        view.backgroundColor = .white
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeAllPropertiesOfFields()
        self.addressbutton.isUserInteractionEnabled = false
        //self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: updateView.frame.size.height, right: 0)
        self.tableView.keyboardDismissMode = .onDrag
        self.textFieldUserIntreraction(isIntraction: false)
        self.updateUserInfo()
        changePin.titleLabel?.font = FontBook.Bold.of(size: 12)
    }
    @objc func editingChangeAction(_ textField: UITextField) {
        editButton.isEnabled(state: satisfiesAllRules())
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateView.addSubview(editButton)
        self.parent?.view.addSubview(updateView)
        if editButton.title(for: .normal) == "SAVE CHANGES" {
            isProfileEditing = self.isProfileInfoReallyChanged()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateView.removeFromSuperview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func changePinAction(_ sender: Any) {
        self.view.endEditing(false)
        guard !isProfileEditing else {
            if let controller = self.navigationController?.topViewController as? BaseViewController {
                controller.openAlertPopupForEditProfile()
                controller.onAlertPopupForEditProfile {[weak self] in
                    self?.changePinAction(self?.changePin as Any)
                }
            }
            return
        }
        let changePinVC = self.storyboard?.instantiateViewController(withIdentifier: "ChangePinViewController") as? ChangePinViewController
        self.navigationController?.pushViewController(changePinVC!, animated: true)
    }
    @IBAction func addressAction(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Burn", bundle: nil)
        let editAddress = storyBoard.instantiateViewController(withIdentifier: "DeliveryAddressVC") as? DeliveryAddressVC
        editAddress?.hiddenTVCell = true
        editAddress?.cellViewModel = self.editAddressModel
        editAddress?.editAddressHandler = { [weak self] data in
            self?.editAddressModel = data
            if let add1 = data?.address1, add1.isNotEmpty(), let add2 = data?.address2, add2.isNotEmpty(), let state = data?.state, state.isNotEmpty(), let city = data?.city, city.isNotEmpty() {
                DispatchQueue.main.async {
                    self?.addressField.set(textViewText: "\(add1), \(add2), \(city), \(state)")
                    self?.editButton.isEnabled(state: (self?.satisfiesAllRules())!)
                    isProfileEditing = (self?.isProfileInfoReallyChanged())!
                }
            }
        }
        self.navigationController?.pushViewController(editAddress!, animated: true)
    }
    deinit {
        print("MyProfileViewController Deinit called")
    }
}
extension MyProfileViewController {
    @objc func handleToggleEditBT(sender: UIButton) {
        if !sender.isSelected {
            sender.isSelected = true
            editButton.setTitle("SAVE CHANGES", for: .normal)
            self.textFieldUserIntreraction(isIntraction: true)
            editButton.isEnabled(state: satisfiesAllRules())
            
            //self.fNameField.textField.becomeFirstResponder()
        } else {
            let canUpdate = fNameField.satisfiesAllTextRules() && lNameField.satisfiesAllTextRules() && emailField.satisfiesAllTextRules() && mobileField.satisfiesAllTextRules() && dobField.satisfiesAllTextRules() && pincodeField.satisfiesAllTextRules() && addressField.satisfiesTextViewTextRules()
            
            guard canUpdate else {
                self.alertMessage()
                return
            }
            self.updateMemberDetails()
            isProfileEditing = false
        }
    }
    
    func updateTogleButton() {
        print("Success - Implementation")
        editButton.setTitle("EDIT PROFILE", for: .normal)
        self.textFieldUserIntreraction(isIntraction: false)
        self.editButton.isSelected = false
    }
    
    func updateMemberDetails() {
        self.startActivityIndicator()
        var mobileno = mobileField.textField.text
        mobileno = mobileno?.toLengthOf(length: 4)
        
        let date = dobField.textField.text
        let dateYYMMDD = Utilities.isValidDateFormateYYMMDD(dateString: date!)
        let params = UserProfileModel(LastName: lNameField.textField.text ?? "", FirstName: fNameField.textField.text ?? "", TotalPoints: nil, AvailablePoints: nil, BlockedPoints: nil, PointsToExpireAmount: nil, UserLoged: nil, EmailAddress: emailField.textField.text ?? "", MobileNumber: mobileno ?? "", CardNumber: nil, DateOfBirth: dateYYMMDD, PinCode: nil, Salutation: nil, ZipCode: pincodeField.textField.text ?? "", City: nil, Region: nil, Address1: nil, Address2: nil, ExtraAddress: nil, UserID: nil, addressSplitModel: self.editAddressModel!)
        updateMember
            .onTokenExpired { [weak self] in
                self?.updateSignInPopUp(typeCodeMsg: "Invalid Token")
                self?.stopActivityIndicator()
            }
            .onError { [weak self] (error) in
                self?.showErrorViewInParent(errorMsg: error)
                self?.updateUserEditProfile(false)
                self?.stopActivityIndicator()
            }
            .onSuccess { [weak self] (successMsg) in
                self?.showErrorViewInParent(errorMsg: successMsg)
                self?.updateTogleButton()
                self?.updateUserEditProfile(true)
                self?.stopActivityIndicator()
            }
            .updateMemberDetails(withParameter: params)
    }
    
    func updateSignInPopUp(typeCodeMsg: String) {
        self.updateInvalidToken(typeCodeMsg)
    }
    func textFieldUserIntreraction(isIntraction: Bool) {
        self.fNameField.textField.isUserInteractionEnabled = isIntraction
        self.lNameField.textField.isUserInteractionEnabled = isIntraction
        self.emailField.textField.isUserInteractionEnabled = isIntraction
        self.mobileField.textField.isUserInteractionEnabled = isIntraction
        self.addressField.textView.isUserInteractionEnabled = isIntraction
        self.pincodeField.textField.isUserInteractionEnabled = isIntraction
        self.dobField.textField.isUserInteractionEnabled = isIntraction
        self.addressbutton.isUserInteractionEnabled = isIntraction
        self.changePin.isEnabled(state: true)
    }
    
    func alertMessage() {
        let alertControll = UIAlertController(title: "Alert", message: "Please enter all the field", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertControll.addAction(okAction)
        self.present(alertControll, animated: true, completion: nil)
    }
    @discardableResult
    func updateEditprofileStatus(closure: @escaping EditProfileUpdateClosure) -> Self {
        self.updateUserEditProfile = closure
        return self
    }
    @discardableResult
    func updateInvalidToken(closure: @escaping InvalidTokenUpdateClosure) -> Self {
        self.updateInvalidToken = closure
        return self
    }
}
extension MyProfileViewController {
    private func openDatePicker() {
        isEditEnabled = true
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        if let date = self.dobField.textField.text {
            self.datePicker.date = dateFormatter.date(from: date)!
        }
        self.dobField.textField.becomeFirstResponder()
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        self.dobField.textField.text = dateFormatter.string(from: sender.date)
    }
    
    private func assignCommonFields(field: DesignableTFView, keyboardType: UIKeyboardType) {
        let font = FontBook.Bold.ofProfileTextField()
        let minFontSize: CGFloat = 10.0
        
        field
            .set(TFFont: font, minFontSize: minFontSize)
            .set(addLineBorder: ColorConstant.grayLineBorderProfile)
            .set(TFkeyboardReturnType: (field == pincodeField) ? .done : .next)
            .set(TFkeyboardType: keyboardType)
            .textField.delegate = self
        
        field.textField.addTarget(self, action: #selector(editingChangeAction(_:)), for: .editingChanged)
        field.titleLable.textColor = ColorConstant.profileTitleTextColor
        field.titleLable.font = FontBook.Regular.ofProfileTextField()
        field.textField.textColor = ColorConstant.textColorPointTitle
        
    }
}
extension MyProfileViewController {
    func updateUserInfo() {
        guard let userDetails = UserProfileUtilities.getUserDetails() else {
            return
        }
        if let firstName = userDetails.FirstName {
            self.fNameField.textField.text = firstName
        } else {
            self.fNameField.textField.text = ""
        }
        if let lastName = userDetails.LastName {
            self.lNameField.textField.text = lastName
        } else {
            self.lNameField.textField.text = ""
        }
        if let email = userDetails.EmailAddress {
            self.emailField.textField.text = email
        } else {
            self.emailField.textField.text = ""
        }
        if let mobileNumber = userDetails.MobileNumber {
            self.mobileNo = mobileNumber
            self.mobileField.textField.text = "+91 \(mobileNumber)"
        } else {
            self.mobileField.textField.text = "+91 "
        }
        if let dob = userDetails.DateOfBirth {
            let dateGiven = Utilities.isValidDateFormateYYMMDD(dateString: dob)
            self.dobField.textField.text = dateGiven
            
        } else {
            self.dobField.textField.text = ""
        }
        if let pincode = userDetails.PinCode {
            self.pincodeField.textField.text = pincode
        } else {
            self.pincodeField.textField.text = ""
        }
        if let address = userDetails.Address1, address.isNotEmpty(), let address2 = userDetails.Address2, address2.isNotEmpty(), let city = userDetails.City, city.isNotEmpty(), let state = userDetails.Region, state.isNotEmpty() {
            self.addressField.set(textViewText: "\(address), \(address2), \(city), \(state)")
        }
        
        let addressData = AddressSplitCellModel(name: "\(userDetails.FirstName ?? "") \(userDetails.LastName ?? "")", address1: userDetails.Address1, address2: userDetails.Address2, city: userDetails.City, state: userDetails.Region, pin: userDetails.PinCode, mobile: userDetails.MobileNumber, emailid: userDetails.EmailAddress, defaultaddress: "", id: userDetails.UserID)
        self.editAddressModel = addressData
    }
    
    private func getFormatedDate(date: String, toGet: Bool) -> String {
        let fullNameArr = date.components(separatedBy: (toGet) ? "-" : "/")
        let dateString = "\(fullNameArr[2])-\(fullNameArr[1])-\(fullNameArr[0])"
        return dateString
    }
}
extension MyProfileViewController {
    private func configureKeyboardType() {
        assignCommonFields(field: self.fNameField, keyboardType: .default)
        assignCommonFields(field: self.lNameField, keyboardType: .default)
        assignCommonFields(field: self.emailField, keyboardType: .emailAddress)
        assignCommonFields(field: self.mobileField, keyboardType: .numberPad)
        assignCommonFields(field: self.dobField, keyboardType: .numberPad)
        assignCommonFields(field: self.pincodeField, keyboardType: .numberPad)
    }
    private func configureMobileField() {
        self.mobileField
            .setToolbar(prevResponder: self.emailField, nextResponder: self.pincodeField)
            .addTextRule { (text) -> TextRuleResult in
                let mobileNo = text.toLengthOf(length: 4)
                return TextRuleResult(withConditionResult: mobileNo.isNotEmpty() && mobileNo.isNumberFormat() && mobileNo.length == 10,
                                      failedMessage: NSLocalizedString("mobile number you have entered is incorrect", comment: "A failure message telling the user that their mobile number needs to be equal of 10/16 characters"))
            }
            .textfiledDidChange {[weak self] in
                isProfileEditing = (self?.isProfileInfoReallyChanged())!
            }
        self.mobileField.isRightViewEnabled = true
        self.mobileField.forgotPass = { [weak self] in
            self?.configureLinkMobilePopup()
        }
    }
    private func configureDOBField() {
        self.dobField
            .setToolbar(prevResponder: nil, nextResponder: nil)
            .addTextRule { (text) -> TextRuleResult in
                return TextRuleResult(withConditionResult: text.isNotEmpty() && text.length <= 10,
                                      failedMessage: NSLocalizedString("Date of birth you have entered is incorrect", comment: "A failure message telling the user that their date of birth needs not be empty"))
            }
            .textfiledDidChange {[weak self] in
                isProfileEditing = (self?.isProfileInfoReallyChanged())!
            }
            .textField.inputView = datePicker
        
        self.dobField.textField.tintColor = .clear
        self.dobField.textField.textColor = ColorConstant.textColorPointTitle
        self.dobField.isRightViewEnabled = false
        self.dobField.titleLable.font = FontBook.Regular.ofProfileTextField()
        self.dobField.titleLable.textColor = ColorConstant.profileTitleTextColor
        //self.dobField.buttonTitle = "Update"
        self.dobField.forgotPass = { [weak self] in
            self?.openDatePicker()
        }
    }
    fileprivate func configureAddressField() {
        self.addressField
            .set(TVFont: FontBook.Bold.ofProfileTextField())
            .set(addLineBorder: ColorConstant.grayLineBorderProfile)
            .set(textViewPlaceHolder: addressPlaceHolderText)
            .addTextRule { (text) -> TextRuleResult in
                return TextRuleResult(withConditionResult: text.isNotEmpty(),
                                      failedMessage: NSLocalizedString("Address you have entered is incorrect", comment: "A failure message telling the user that their address needs not be empty"))
            }
            .textfiledDidChange {[weak self] in
                isProfileEditing = (self?.isProfileInfoReallyChanged())!
            }
            .textView.delegate = self
        
        self.addressField.titleLable.textColor = ColorConstant.profileTitleTextColor
        self.addressField.titleLable.font = FontBook.Regular.of(size: 12)
        self.addressField.textView.textColor = ColorConstant.textColorPointTitle
    }
    
    private func initializeAllPropertiesOfFields() {
        self.fNameField
            .setToolbar(prevResponder: nil, nextResponder: self.lNameField)
            .addTextRule { (text) -> TextRuleResult in
                return TextRuleResult(withConditionResult: text.isNotEmpty(),
                                      failedMessage: NSLocalizedString("First Name should not be empty", comment: "A failure message telling the user that their name needs not be empty"))
        }
            .textfiledDidChange {[weak self] in
                isProfileEditing = (self?.isProfileInfoReallyChanged())!
        }
        self.lNameField
            .setToolbar(prevResponder: self.fNameField, nextResponder: self.emailField)
            .addTextRule { (text) -> TextRuleResult in
                return TextRuleResult(withConditionResult: text.isNotEmpty(),
                                      failedMessage: NSLocalizedString("Last Name should not be empty", comment: "A failure message telling the user that their name needs not be empty"))
            }
            .textfiledDidChange {[weak self] in
                isProfileEditing = (self?.isProfileInfoReallyChanged())!
            }
        self.emailField
            .set(autoCapital: .none)
            .setToolbar(prevResponder: self.lNameField, nextResponder: self.mobileField)
            .addTextRule { (text) -> TextRuleResult in
                return TextRuleResult(withConditionResult: text.isNotEmpty() && text.isValidEmailId(),
                                      failedMessage: NSLocalizedString("Email you have entered is incorrect", comment: "A failure message telling the user that their email needs not be empty"))
            }
            .textfiledDidChange {[weak self] in
                isProfileEditing = (self?.isProfileInfoReallyChanged())!
            }
        
        self.pincodeField
            .setToolbar(prevResponder: self.mobileField, nextResponder: nil)
            .addTextRule { (text) -> TextRuleResult in
                return TextRuleResult(withConditionResult: text.isNotEmpty() && text.isNumberFormat() && text.length == 6,
                                      failedMessage: NSLocalizedString("Pincode you have entered is incorrect", comment: "A failure message telling the user that their pincode needs not be empty"))
            }
            .textfiledDidChange {[weak self] in
                isProfileEditing = (self?.isProfileInfoReallyChanged())!
            }
        configureAddressField()
        configureKeyboardType()
        configureMobileField()
        configureDOBField()
    }
}
extension MyProfileViewController {
    
    fileprivate func configureLinkMobilePopup() {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        self.popPassword = Bundle.main.loadNibNamed(passwordAlertID, owner: self, options: nil)?.first as? PasswordPopUp
        self.popPassword?.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)
        self.config
            .set(diplayDOB: false)
            .set(hideClosePasswordPopUp: false)
            .set(hidePasswordInstruction: true)
            .set(pinGenerateString: NSLocalizedString("GENERATE OTP", comment: "GENERATE OTP"))
            .set(otpPlaceholderString: NSLocalizedString("Enter New Mobile Number", comment: "Enter New Mobile Number"))
            .set(titlePasswordString: NSLocalizedString("UPDATE MOBILE NUMBER", comment: "UPDATE MOBILE NUMBER"))
            .set(descriptionPasswordString: NSLocalizedString("Please Enter Your New Mobile Number", comment: "Please Enter Your New Mobile Number"))
            .set(textFieldText: "")
            .textRule((length: 10, message: NSLocalizedString("mobile number you have entered is incorrect", comment: "A failure message telling the user that their mobile number needs to be correct")))
        
        self.popPassword?.initWithConfiguration(configuration: config)
        
        window.addSubview(self.popPassword!)
        self.popPassword?.generateOTPHandler = { [weak self] (mobileNo, _) in
            self?.mobileNo = mobileNo
            self?.generateOTPForLinkMobile(mobileNo)
        }
    }
    
    fileprivate func openGeneratePinOTP() {
        self.config
            .set(diplayDOB: false)
            .set(hideClosePasswordPopUp: false)
            .set(hidePasswordInstruction: false)
            .set(pinGenerateString: NSLocalizedString("VERIFY NOW", comment: "VERIFY NOW"))
            .set(otpPlaceholderString: NSLocalizedString("Enter OTP here", comment: "Enter OTP here"))
            .set(titlePasswordString: NSLocalizedString("ENTER ONE TIME PASSWORD", comment: "ENTER ONE TIME PASSWORD"))
            .set(descriptionPasswordString: NSLocalizedString("We have sent otp to your new mobile number", comment: "We have sent otp to your new mobile number"))
            .set(instructionPasswordString: getAttributedTextForOtp())
            .set(textFieldText: "")
            .textRule((length: 6, message: NSLocalizedString("OTP you have entered is incorrect", comment: "OTP you have entered is incorrect")))
        
        popPassword?.initWithConfiguration(configuration: config)
        popPassword?.generateOTPHandler = { [weak self] (otp, _) in
            self?.linkMobile((self?.mobileNo)!, otp: otp)
        }
        popPassword?.linkActionHandler = { [weak self] in
            self?.generateOTPForLinkMobile((self?.mobileNo)!)
        }
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
    private func openAlertPopForSuccess(withMessage message: String) {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        let popUpView = Bundle.main.loadNibNamed(alertPopUpID, owner: self, options: nil)?.first as? AlertPopUp
        popUpView?.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)
        window.addSubview(popUpView!)
        
        let config = PopUpConfiguration()
            .set(hideConfirmButton: true)
            .set(hideOkButton: false)
            .set(hideCancelButton: true)
            .set(titleText: NSLocalizedString("SUCCESS", comment: "SUCCESS"))
            .set(desText: message)
        
        popUpView?.initWithConfiguration(configuration: config)
        popUpView?.OkActionHandler = {
            self.popPassword?.removeFromSuperview()
        }
    }
}
extension MyProfileViewController {
    fileprivate func generateOTPForLinkMobile(_ mobileNo: String) {
        if mobileNo.length == 10 {
            let authToken = UserProfileUtilities.getAuthenticationToken()
            let window = UIApplication.shared.keyWindow
            window?.startActivityIndicator()
            updateMember
                .onError(error: { [weak self]( error ) in
                    print("generateOTPForLinkMobile - \(error)")
                    window?.stopActivityIndicator()
                    DispatchQueue.main.async {
                        self?.popPassword?.updateErrorMessage(errorMessage: error)
                    }
                })
                .onSuccess(success: { [weak self] ( successMsg ) in
                    print("generateOTPForLinkMobile - \(successMsg)")
                    window?.stopActivityIndicator()
                    self?.openGeneratePinOTP()
                    DispatchQueue.main.async {
                        self?.popPassword?.updateErrorMessage(errorMessage: successMsg, textColor: ColorConstant.myTranscationPointColorGreen)
                    }
                })
                .generateOTPForLinkMobile(withMobileNo: mobileNo, token: authToken)
        }
    }
    fileprivate func linkMobile(_ mobileNo: String, otp: String) {
        if mobileNo.length == 10 {
            let authToken = UserProfileUtilities.getAuthenticationToken()
            let window = UIApplication.shared.keyWindow
            window?.startActivityIndicator()
            updateMember
                .onError(error: { [weak self]( error ) in
                    print("linkMobile - \(error)")
                    window?.stopActivityIndicator()
                    DispatchQueue.main.async {
                        self?.popPassword?.updateErrorMessage(errorMessage: error)
                    }
                })
                .onSuccess(success: { [weak self] ( successMsg ) in
                    print("linkMobile - \(successMsg)")
                    window?.stopActivityIndicator()
                    self?.popPassword?.removeFromSuperview()
                    self?.openAlertPopForSuccess(withMessage: successMsg)
                    self?.mobileField.textField.text = "+91 \(mobileNo)"
                    UserProfileUtilities.setUserData(withKeyandValue: kMobileNumber, value: mobileNo)
                })
                .linkMobile(mobileNo: mobileNo, otp: otp, token: authToken)
        }
    }
}
extension MyProfileViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let height = cellHeights[indexPath] else {
            return 100.0
        }
        return height
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
        print(cell.isHidden)
        if cell.isHidden == true {
            DispatchQueue.main.async { [weak cell] in
                cell?.layoutSubviews()
                cell?.layoutIfNeeded()
                cell?.isHidden = false
            }
        }
    }
}

extension MyProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case fNameField.textField:
            lNameField.textField.becomeFirstResponder()
        case lNameField.textField:
            emailField.textField.becomeFirstResponder()
        case emailField.textField:
            mobileField.textField.becomeFirstResponder()
        case mobileField.textField:
            addressField.textView.becomeFirstResponder()
        case pincodeField.textField:
            pincodeField.textField.resignFirstResponder()
        default:
            break
        }
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.fNameField.textField {
            if let view = self.fNameField.superview {
                self.tableView.scrollRectToVisible(view.frame, animated: true)
            }
        }
        return (textField == self.dobField.textField) || (textField == self.mobileField.textField)  ? isEditEnabled : true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

        getSelectedField(textField: textField).set(addLineBorder: ColorConstant.shopNowButtonBGColor)
        getSelectedField(textField: textField).clearInlineError()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        getSelectedField(textField: textField).applyAllTextRules()
        
        if textField == self.pincodeField.textField {
            tableView.scrollToRow(at: IndexPath(row: 2, section: 0), at: .top, animated: false)
        }
        
        if textField == self.emailField.textField {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
        
        getSelectedField(textField: textField).set(addLineBorder: ColorConstant.grayLineBorderProfile)
        updateWarnings()
        isEditEnabled = false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else {
            return true
        }
        
        if textField.textInputMode == nil {
            return false
        }
        
        isProfileEditing = self.isProfileInfoReallyChanged()

        if textField == emailField.textField {
            if string >= "A" && string <= "Z" {
                textField.insertText(string.lowercased())
                return false
            }
            return true
        }

        let newLength = text.count + string.count - range.length

        if let mobileno = mobileField.textField.text, textField == mobileField.textField {
            if mobileno.count <= 4 && string.length == 0 {
                return false
            } else {
                return string.allowNumbersOnly() && newLength <= 14
            }
        }
        
        if textField == self.pincodeField.textField {
            return string.allowNumbersOnly() && newLength <= 6
        }
        
        if textField == self.fNameField.textField {
            return newLength <= 26 && string.allowAlphaNumSpecialChars()
        }
        if textField == self.lNameField.textField {
            return newLength <= 26 && string.allowAlphaNumSpecialChars()
        }
        return true
    }
}

extension MyProfileViewController: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return false
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty || textView.text == addressPlaceHolderText {
            textView.text = addressPlaceHolderText
        }
        editButton.isEnabled(state: satisfiesAllRules())
        updateWarnings()
    }
}

extension MyProfileViewController {
    
    fileprivate func satisfiesAllRules() -> Bool {
        return (self.fNameField.satisfiesAllTextRules() && self.lNameField.satisfiesAllTextRules() && self.mobileField.satisfiesAllTextRules() && self.dobField.satisfiesAllTextRules() && self.emailField.satisfiesAllTextRules() && self.pincodeField.satisfiesAllTextRules() && addressField.satisfiesTextViewTextRules())
    }
    
    fileprivate func getSelectedField(textField: UITextField) -> DesignableTFView {
        switch textField {
        case fNameField.textField:
            return fNameField
        case lNameField.textField:
            return lNameField
        case emailField.textField:
            return emailField
        case mobileField.textField:
            return mobileField
        case dobField.textField:
            return dobField
        default:
            return pincodeField
        }
    }
    
    fileprivate func updateWarnings() {
        self.tableView.updateTableView(animation: false)
    }
}
extension MyProfileViewController {
    fileprivate func isProfileInfoReallyChanged() -> Bool {
        guard let userDetails = UserProfileUtilities.getUserDetails() else {
            return false
        }
        
        if self.fNameField.textField.text != userDetails.FirstName || self.lNameField.textField.text != userDetails.LastName || self.emailField.textField.text != userDetails.EmailAddress || self.mobileNo != userDetails.MobileNumber || self.dobField.textField.text != Utilities.isValidDateFormateYYMMDD(dateString: userDetails.DateOfBirth ?? "") || self.pincodeField.text != userDetails.PinCode {
            return true
        } else {
            if let address = userDetails.Address1, address.isNotEmpty(), let address2 = userDetails.Address2, address2.isNotEmpty(), let city = userDetails.City, city.isNotEmpty(), let state = userDetails.Region, state.isNotEmpty() {
                return !(self.addressField.text == "\(address), \(address2), \(city), \(state)")
            }
             return false
        }
    }
}
