//
//  DeliveryAddressVC.swift
//  PayBack
//
//  Created by Mohsin Surani on 07/11/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class DeliveryAddressVC: UITableViewController {

    @IBOutlet weak private var tableview: UITableView!
    @IBOutlet weak fileprivate var nameTVCell: UITableViewCell!
    @IBOutlet weak fileprivate var checkDefaultAddressTVCell: UITableViewCell!
    @IBOutlet weak fileprivate var emailTVCell: UITableViewCell!
    @IBOutlet weak fileprivate var mobileNumTVCell: UITableViewCell!
    @IBOutlet weak fileprivate var pincodeTVCell: UITableViewCell!
    @IBOutlet weak fileprivate var nameField: DesignableTFView!
    @IBOutlet weak fileprivate var address1Field: DesignableTFView!
    @IBOutlet weak fileprivate var address2Field: DesignableTFView!
    @IBOutlet weak fileprivate var cityField: DesignableTFView!
    @IBOutlet weak fileprivate var stateField: DesignableTFView!
    @IBOutlet weak fileprivate var pincodeField: DesignableTFView!
    @IBOutlet weak fileprivate var mobileField: DesignableTFView!
    @IBOutlet weak fileprivate var emailField: DesignableTFView!
    @IBOutlet weak fileprivate var defaultButton: UIButton!
    
    var hiddenTVCell: Bool = false
    fileprivate var cellHeights = [IndexPath: CGFloat]()
    var cellViewModel: AddressSplitCellModel?
    var navView = UIView()
    var addNewAddressHandler: (() -> Void)?
    var updateAddressHandler: ((AddressSplitCellModel?) -> Void)?
    var editAddressHandler: ((AddressSplitCellModel?) -> Void)?
    let deliveryAddressNWController = CartReviewNWController()

    lazy var editButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH, height: 49))
        button.backgroundColor = UIColor(red: 238 / 255, green: 0 / 255, blue: 107 / 255, alpha: 1)
        button.setTitle("UPDATE ADDRESS", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 15)
        button.addTarget(self, action: #selector(handleUpdateAddress), for: .touchUpInside)
        return button
    }()
    
    lazy var updateView: UIView = {
        var y = ScreenSize.SCREEN_HEIGHT - 49
        var height: CGFloat = 49
        if UIDevice.current.iPhoneX {
            y = ScreenSize.SCREEN_HEIGHT - 49 - 32
            height = 49 + 32
        }
        let view = UIView(frame: CGRect(x: 0, y: y, width: ScreenSize.SCREEN_WIDTH, height: height))
        view.backgroundColor = .white
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if hiddenTVCell {
            fromMyProfle_initializeAllPropertiesOfFields()
        } else {
            initializeAllPropertiesOfFields()
        }
        
        navView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH, height: UIDevice.current.iPhoneX ? 64 + 22 : 64))
        navView.backgroundColor = .white
        let designableView = DesignableNav()
        if hiddenTVCell {
            designableView.title = "Edit Address"
        } else {
             designableView.title = "Delivery Address"
        }
        designableView.frame = CGRect(x: 0, y: UIDevice.current.iPhoneX ? 22 + 20 : 20, width: ScreenSize.SCREEN_WIDTH, height: DeviceType.IS_IPAD ? 65 : 49)
        navView.addSubview(designableView)
        designableView.backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        
        updateView.addSubview(editButton)
        self.defaultButton.imageView?.contentMode = .scaleAspectFit
        self.defaultButton.imageView?.clipsToBounds = true
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.tableView.contentInset = UIEdgeInsets(top: navView.frame.height, left: 0, bottom: editButton.frame.size.height + 20, right: 0)
        
        if !BaseViewController().checkConnection() {
            let connectionView = Bundle.main.loadNibNamed("ConnectionErrorView", owner: self, options: nil)?.first as? ConnectionErrorView
            connectionView?.frame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: self.view.frame.height)
            UIApplication.shared.keyWindow?.addSubview(connectionView!)
            connectionView?.connectionSuccess = { [weak self] in
                self?.setViewInWindow()
            }
        } else {
            setViewInWindow()
        }
    }
    
    private func setViewInWindow() {
        self.navigationController?.view.addSubview(updateView)
        self.navigationController?.view.addSubview(navView)

        self.navigationController?.isNavigationBarHidden = true
        editButton.isEnabled(state: false)
        
        if cellViewModel != nil {
            setDataInFields()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.updateView.removeFromSuperview()
        self.navView.removeFromSuperview()
    }
    
    deinit {
        print("DeliveryAddressVC deinit called")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension DeliveryAddressVC {
    
    fileprivate func fromMyProfle_initializeAllPropertiesOfFields() {
        self.address1Field
            .setToolbar(prevResponder: nil, nextResponder: self.address2Field)
            .addTextRule { (text) -> TextRuleResult in
                return TextRuleResult(withConditionResult: text.isNotEmpty() ,
                                      failedMessage: NSLocalizedString("first address you have entered is incorrect", comment: "A failure message telling the user that their address one needs not be empty"))
        }
        
        self.address2Field
            .setToolbar(prevResponder: self.address1Field, nextResponder: self.cityField)
            .addTextRule { (text) -> TextRuleResult in
                return TextRuleResult(withConditionResult: text.isNotEmpty() ,
                                      failedMessage: NSLocalizedString("second address you have entered is incorrect", comment: "A failure message telling the user that their address second needs not be empty"))
        }
        
        self.cityField
            .setToolbar(prevResponder: self.address2Field, nextResponder: self.stateField)
            .addTextRule { (text) -> TextRuleResult in
                return TextRuleResult(withConditionResult: text.isNotEmpty() ,
                                      failedMessage: NSLocalizedString("city you have entered is incorrect", comment: "A failure message telling the user that their state needs not be empty"))
        }
        
        self.stateField
            .setToolbar(prevResponder: self.cityField, nextResponder: nil)
            .addTextRule { (text) -> TextRuleResult in
                return TextRuleResult(withConditionResult: text.isNotEmpty() ,
                                      failedMessage: NSLocalizedString("state you have entered is incorrect", comment: "A failure message telling the user that their state needs not be empty"))
        }
        
        commonPropAssign()
    }
    
    fileprivate func configureAddressFields() {
        self.address1Field
            .setToolbar(prevResponder: self.nameField, nextResponder: self.address2Field)
            .addTextRule { (text) -> TextRuleResult in
                return TextRuleResult(withConditionResult: text.isNotEmpty() ,
                                      failedMessage: NSLocalizedString("first address you have entered is incorrect", comment: "A failure message telling the user that their address one needs not be empty"))
        }
        self.address2Field
            .setToolbar(prevResponder: self.address1Field, nextResponder: self.cityField)
            .addTextRule { (text) -> TextRuleResult in
                return TextRuleResult(withConditionResult: text.isNotEmpty() ,
                                      failedMessage: NSLocalizedString("second address you have entered is incorrect", comment: "A failure message telling the user that their address second needs not be empty"))
        }
    }
    
    fileprivate func initializeAllPropertiesOfFields() {
        self.nameField
            .setToolbar(prevResponder: nil, nextResponder: self.address1Field)
            .addTextRule { (text) -> TextRuleResult in
                return TextRuleResult(withConditionResult: text.isNotEmpty() && text.length <= 26 ,
                                      failedMessage: NSLocalizedString("Name you have entered is incorrect", comment: "A failure message telling the user that their name needs not be empty"))
        }
        self.emailField
            .setToolbar(prevResponder: self.mobileField, nextResponder: nil)
            .set(autoCapital: .none)
            .addTextRule { (text) -> TextRuleResult in
                return TextRuleResult(withConditionResult: text.isNotEmpty() && text.isValidEmailId() ,
                                      failedMessage: NSLocalizedString("email you have entered is incorrect", comment: "A failure message telling the user that their email needs not be empty"))
        }
        self.mobileField
            .setToolbar(prevResponder: self.pincodeField, nextResponder: self.emailField)
            .addTextRule { (text) -> TextRuleResult in
                return TextRuleResult(withConditionResult: text.length == 10 && text.isNotEmpty() && text.isNumberFormat() ,
                                      failedMessage: NSLocalizedString("mobile number you have entered is incorrect", comment: "A failure message telling the user that their mobile number needs to be equal of 10/16 characters"))
        }
        configureAddressFields()
        self.cityField
            .setToolbar(prevResponder: self.address2Field, nextResponder: self.stateField)
            .addTextRule { (text) -> TextRuleResult in
                return TextRuleResult(withConditionResult: text.isNotEmpty() ,
                                      failedMessage: NSLocalizedString("city you have entered is incorrect", comment: "A failure message telling the user that their state needs not be empty"))
        }
        self.stateField
            .setToolbar(prevResponder: self.cityField, nextResponder: self.pincodeField)
            .addTextRule { (text) -> TextRuleResult in
                return TextRuleResult(withConditionResult: text.isNotEmpty() ,
                                      failedMessage: NSLocalizedString("state you have entered is incorrect", comment: "A failure message telling the user that their state needs not be empty"))
        }
        self.pincodeField
            .setToolbar(prevResponder: self.stateField, nextResponder: self.mobileField)
            .addTextRule { (text) -> TextRuleResult in
                return TextRuleResult(withConditionResult: text.isNotEmpty() && text.isNumberFormat() && text.length == 6 ,
                                      failedMessage: NSLocalizedString("pincode you have entered is incorrect", comment: "A failure message telling the user that their pincode needs not be empty"))
        }
        
        commonPropAssign()
    }
}
extension DeliveryAddressVC {
    fileprivate func commonPropAssign() {
        assignCommonFields(field: self.nameField, keyboardType: .default)
        assignCommonFields(field: self.emailField, keyboardType: .emailAddress)
        assignCommonFields(field: self.mobileField, keyboardType: .numberPad)
        assignCommonFields(field: self.address1Field, keyboardType: .default)
        assignCommonFields(field: self.address2Field, keyboardType: .default)
        assignCommonFields(field: self.cityField, keyboardType: .default)
        assignCommonFields(field: self.stateField, keyboardType: .default)
        assignCommonFields(field: self.pincodeField, keyboardType: .numberPad)
    }
    
    private func assignCommonFields(field: DesignableTFView, keyboardType: UIKeyboardType) {
        let font = FontBook.Regular.ofTitleSize()
        let minFontSize: CGFloat = 9.0
        
        field
            .set(TFFont: font, minFontSize: minFontSize)
            .set(addLineBorder: .lightGray)
            .set(TFkeyboardType: keyboardType)
            .set(TFkeyboardReturnType: (field == ((hiddenTVCell) ? self.stateField : self.emailField)) ? .done : .next)
            .textField.delegate = self
        
        field.textField.addTarget(self, action: #selector(editingChangeAction(_:)), for: .editingChanged)
    }
    
    @objc func editingChangeAction(_ textField: UITextField) {
        
        if hiddenTVCell {
            editButton.isEnabled(state: (self.address1Field.satisfiesAllTextRules() && self.address2Field.satisfiesAllTextRules() && self.cityField.satisfiesAllTextRules() && self.stateField.satisfiesAllTextRules()))
        } else {
            editButton.isEnabled(state: (self.nameField.satisfiesAllTextRules() && self.emailField.satisfiesAllTextRules() && self.mobileField.satisfiesAllTextRules() && self.address1Field.satisfiesAllTextRules() && self.address2Field.satisfiesAllTextRules() && self.cityField.satisfiesAllTextRules() && self.stateField.satisfiesAllTextRules() && self.pincodeField.satisfiesAllTextRules()))
        }
    }
    
    @objc func handleUpdateAddress(sender: UIButton) {
        if hiddenTVCell {
            myProfile_UpdateAddressField()
        } else {
            updateAddressFromFields()
        }
    }
    
    private func myProfile_UpdateAddressField() {
        let data = AddressSplitCellModel(name: self.nameField.textField.text!, address1: self.address1Field.textField.text!, address2: self.address2Field.textField.text!, city: self.cityField.textField.text!, state: self.stateField.textField.text!, pin: self.pincodeField.textField.text!, mobile: self.mobileField.textField.text!, emailid: self.emailField.textField.text!, defaultaddress: "", id: cellViewModel?.id)
        self.editAddressHandler!(data)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func updateAddressFromFields() {
        let isDefault = (NSNumber(value: (defaultButton.isSelected)))

        if cellViewModel != nil { // update
            let data1 = AddressSplitCellModel(name: self.nameField.textField.text!, address1: self.address1Field.textField.text!, address2: self.address2Field.textField.text!, city: self.cityField.textField.text!, state: self.stateField.textField.text!, pin: self.pincodeField.textField.text!, mobile: self.mobileField.textField.text!, emailid: self.emailField.textField.text!, defaultaddress: "\(isDefault)", id: cellViewModel?.id)
            
            updateDeliveryAddressRequest(userid: UserProfileUtilities.getUserID(), data: data1)
        } else { // add
            let data1 = AddressSplitCellModel(name: self.nameField.textField.text!, address1: self.address1Field.textField.text!, address2: self.address2Field.textField.text!, city: self.cityField.textField.text!, state: self.stateField.textField.text!, pin: self.pincodeField.textField.text!, mobile: self.mobileField.textField.text!, emailid: self.emailField.textField.text!, defaultaddress: "\(isDefault)", id: "")
            
            addDeliveryAddressRequest(userid: UserProfileUtilities.getUserID(), data: data1)
        }
    }
    
    private func addDeliveryAddressRequest(userid: String, data: AddressSplitCellModel) {
        deliveryAddressNWController.onError { [weak self] (error) in
            self?.view?.errorMsgView(errorMsg: error)
            }.onInsertSuccess { [weak self] in
                self?.addNewAddressHandler?()
                self?.navigationController?.popViewController(animated: true)
            }.addAddresss(userid: userid, data: data)
    }
    
    private func updateDeliveryAddressRequest(userid: String, data: AddressSplitCellModel) {
        deliveryAddressNWController
            .onError { [weak self] (error) in
                self?.view?.errorMsgView(errorMsg: error)
            }.onUpdateSuccess { [weak self] in
                self?.updateAddressToModel()
                self?.updateAddressHandler?(data)
                self?.navigationController?.popViewController(animated: true)
            }.updateAddresss(userid: userid, data: data)
    }
    
    @IBAction func defaultAddressAction(_ sender: UIButton) {
        if cellViewModel != nil {
            editButton.isEnabled(state: (self.nameField.satisfiesAllTextRules() && self.emailField.satisfiesAllTextRules() && self.mobileField.satisfiesAllTextRules() && self.address1Field.satisfiesAllTextRules() && self.address2Field.satisfiesAllTextRules() && self.cityField.satisfiesAllTextRules() && self.stateField.satisfiesAllTextRules() && self.pincodeField.satisfiesAllTextRules()))
        }
        sender.isSelected = !sender.isSelected
    }
}

extension DeliveryAddressVC {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if hiddenTVCell {
            let myCell = super.tableView(tableView, cellForRowAt: indexPath)
            if myCell == self.nameTVCell || myCell == self.mobileNumTVCell || myCell == self.emailTVCell || myCell == self.checkDefaultAddressTVCell || myCell == self.pincodeTVCell {
                return 0
            }
        }
        if indexPath.row == 8 {
            return 40
        }
        return 100
    }
}

extension DeliveryAddressVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case nameField.textField:
            address1Field.textField.becomeFirstResponder()
        case address1Field.textField:
            address2Field.textField.becomeFirstResponder()
        case address2Field.textField:
            cityField.textField.becomeFirstResponder()
        case cityField.textField:
            stateField.textField.becomeFirstResponder()
        case stateField.textField:
            if hiddenTVCell {
                textField.resignFirstResponder()
            } else {
                pincodeField.textField.becomeFirstResponder()
            }
        case pincodeField.textField:
            mobileField.textField.becomeFirstResponder()
        case mobileField.textField:
            emailField.textField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        getSelectedField(textField: textField).set(addLineBorder: ColorConstant.textFieldUnderLineColor)
        getSelectedField(textField: textField).clearInlineError()
        getSelectedField(textField: textField).warningInfo = " "
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        getSelectedField(textField: textField).set(addLineBorder: .lightGray)
        if (textField.text?.isNotEmpty())! {
            getSelectedField(textField: textField).applyAllTextRules()
        }
        updateWarnings()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else {
            return true
        }
        
        if textField.textInputMode == nil {
            return false
        }
        
        let newLength = text.count + string.count - range.length
        
        if textField == self.pincodeField.textField {
            return string.allowNumbersOnly() && newLength <= 6
        } else if textField == self.mobileField.textField {
            return string.allowNumbersOnly() && newLength <= 10
        } else if textField == self.emailField.textField {
            if string >= "A" && string <= "Z" {
                textField.insertText(string.lowercased())
                return false
            }
            return true
        } else if textField == self.nameField.textField {
            return newLength <= 26 && string.allowAlphaNumSpecialChars()
        } else {
            return string.allowAlphaNumSpecialChars()
        }
    }
}

extension DeliveryAddressVC {
    fileprivate func getSelectedField(textField: UITextField) -> DesignableTFView {
        switch textField {
        case nameField.textField:
            return nameField
        case emailField.textField:
            return emailField
        case mobileField.textField:
            return mobileField
        case pincodeField.textField:
            return pincodeField
        case address1Field.textField:
            return address1Field
        case address2Field.textField:
            return address2Field
        case cityField.textField:
            return cityField
        default:
            return stateField
        }
    }
    
    fileprivate func updateWarnings() {
        tableView.updateTableView(animation: false)
    }
    
    fileprivate func updateAddressToModel() {
        if let name = self.nameField.textField.text {
            cellViewModel?.name = name
        }
        if let mobile = self.mobileField.textField.text {
            cellViewModel?.mobile = mobile
        }
        if let emailid = self.emailField.textField.text {
            cellViewModel?.emailid = emailid
        }
        if let address2 = self.address2Field.textField.text {
            cellViewModel?.address2 = address2
        }
        if let address1 = self.address1Field.textField.text {
            cellViewModel?.address1 = address1
        }
        if let state = self.stateField.textField.text {
            cellViewModel?.state = state
        }
        if let city = self.cityField.textField.text {
            cellViewModel?.city = city
        }
        if let pincode = self.pincodeField.textField.text {
            cellViewModel?.pin = pincode
        }
        
        let isDefault = (NSNumber(value: (defaultButton.isSelected)))
        cellViewModel?.defaultaddress = "\(isDefault)"
    }
    
    fileprivate func setDataInFields() {
        self.nameField.textField.text = cellViewModel?.name
        self.mobileField.textField.text = cellViewModel?.mobile
        self.emailField.textField.text = cellViewModel?.emailid
        self.address2Field.textField.text = cellViewModel?.address2
        self.address1Field.textField.text = cellViewModel?.address1
        self.stateField.textField.text = cellViewModel?.state
        self.cityField.textField.text = cellViewModel?.city
        self.pincodeField.textField.text = cellViewModel?.pin
        self.defaultButton.isSelected = false
        if let isDefault = cellViewModel?.defaultaddress {
            self.defaultButton.isSelected = NSString(string: isDefault).boolValue
        }
    }
}
