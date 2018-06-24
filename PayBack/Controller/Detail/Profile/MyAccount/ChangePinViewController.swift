//
//  ChangePinViewController.swift
//  PayBack
//
//  Created by Dinakaran M on 05/10/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class ChangePinViewController: BaseViewController {
    
    fileprivate let cellIdentifier = "ChangePinTVcell"
    @IBOutlet weak fileprivate var tableview: UITableView!
    @IBOutlet weak fileprivate var saveButton: UIButton!
    @IBOutlet weak private var cancelButton: UIButton!
    var cellInstance: ChangePinTVcell?
    var changePinNWController = GetNewPinNetworkController()
        
    @IBAction func CancelSaveAction(_ sender: UIButton) {
        if sender.tag == 0 {
            print("Cancel")
            self.cancelButton.backgroudColorWithTitleColor(color: ColorConstant.buttonBGColor, titleColor: .white)
            self.saveButton.backgroudColorWithTitleColor(color: .white, titleColor: .black)
            self.navigationController?.popViewController(animated: true)
        } else {
            if let cell = cellInstance {
                self.startActivityIndicator()
                self.saveButton.backgroudColorWithTitleColor(color: ColorConstant.buttonBGColor, titleColor: .white)
                self.cancelButton.backgroudColorWithTitleColor(color: .white, titleColor: .black)
                    let (oldPin, newPin) = cell.getPin()
                    changePinNWController
                        .onTokenExpired { [weak self] in
                            self?.updateSignInPopUp(typeCodeMsg: "Invalid Token")
                            self?.stopActivityIndicator()
                        }
                        .onError(error: { [weak self] (error) in
                            self?.showErrorView(errorMsg: error)
                            self?.stopActivityIndicator()
                        })
                        .onSuccess(success: { [weak self] (successMsg) in
                            print(successMsg)
                            self?.showErrorViewInWindow(errorMsg: successMsg)
                            self?.stopActivityIndicator()
                            self?.navigationController?.popViewController(animated: true)
                        }).getChangedPin(oldSecretPin: oldPin, newSecretPin: newPin)
                }
            }
    }
   
    func updateSignInPopUp(typeCodeMsg: String) {
        self.showErrorView(errorMsg: "\(typeCodeMsg) - please try to SignIn")
        self.signInPopUp()
    }
    override func userLogedIn(status: Bool) {
        print("From Change PIN - User Loged In Success")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserverAssigned()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.estimatedRowHeight = 100
        tableview.rowHeight = UITableViewAutomaticDimension
        tableview.tableFooterView = UIView(frame: .zero)
        tableview.keyboardDismissMode = .onDrag
        
        self.saveButton.backgroudColorWithTitleColor(color: ColorConstant.buttonBGColor, titleColor: .white)
        self.cancelButton.backgroudColorWithTitleColor(color: .white, titleColor: .black)
        self.saveButton.isEnabled(state: false)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func removeObserverAssigned() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("Deint - ChangePinViewController")
    }
}
extension ChangePinViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ChangePinTVcell
        cellInstance = cell
        cell?.warningHandler = { [weak self] in
            self?.tableview.updateTableView(animation: false)
        }
        cell?.validationSuccessHandler(closure: { [weak self] (validationState) in
            if validationState {
                self?.saveButton.isEnabled(state: true)
            } else {
                self?.saveButton.isEnabled(state: false)
            }
        })
        
        cell?.oldPinHandler = { [weak self] (Data, Data1) in
           self?.configureContentForOldPinField(data: Data, data1: Data1, indexPath: indexPath)
        }
        cell?.newPinHandler = { [weak self] (Data, Data1) in
            self?.configureContentForNewPinField(data: Data, data1: Data1, indexPath: indexPath)
        }
        cell?.confirmPinHandler = { [weak self] (Data, Data1) in
            self?.configureContentForConfirmPinField(data: Data, data1: Data1, indexPath: indexPath)
        }
        return cell!
    }
}

extension ChangePinViewController {
    @objc func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            self.tableview.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    fileprivate func configureContentForOldPinField(data: CGFloat, data1: CGFloat, indexPath: IndexPath) {
        self.tableview.setContentOffset(CGPoint(x: 0, y: data + data1 + ((DeviceType.IS_IPHONE_5) ? 20 : 40)), animated: false)
        self.tableview.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: data1 + ((DeviceType.IS_IPHONE_5) ? 20 : 40), right: 0)
        self.scrollToBottom(indexPath: indexPath)
    }
    
    fileprivate func configureContentForNewPinField(data: CGFloat, data1: CGFloat, indexPath: IndexPath) {
        self.tableview.setContentOffset(CGPoint(x: 0, y: data + data1 + ((DeviceType.IS_IPHONE_5) ? 50 : 40)), animated: false)
        self.tableview.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: data1 + ((DeviceType.IS_IPHONE_5) ? 50 : 40), right: 0)
        self.scrollToBottom(indexPath: indexPath)
    }
    
    fileprivate func configureContentForConfirmPinField(data: CGFloat, data1: CGFloat, indexPath: IndexPath) {
        self.tableview.setContentOffset(CGPoint(x: 0, y: data + data1 - 30), animated: false)
        self.tableview.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: data + data1 - 100, right: 0)
        self.scrollToBottom(indexPath: indexPath)
    }
    
    fileprivate func scrollToBottom(indexPath: IndexPath) {
        self.tableview.scrollToRow(at: indexPath, at: .bottom, animated: false)
    }
}
