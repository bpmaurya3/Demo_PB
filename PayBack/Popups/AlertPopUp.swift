//
//  AlertPopUp.swift
//  PaybackPopup
//
//  Created by Mohsin.Surani on 17/08/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class AlertPopUp: UIView, UIGestureRecognizerDelegate {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    @IBOutlet weak private var popUpView: UIView!
    @IBOutlet weak private var lblAccBlock: UILabel!
    @IBOutlet weak private var lblDesc: UILabel!
    @IBOutlet weak private var btnOk: UIButton!
    @IBOutlet weak private var btnConfirm: UIButton!
    @IBOutlet weak private var btnCancel: UIButton!
    
    var OkActionHandler: (() -> Void)?
    var cancelActionHandler: (() -> Void)?
    var confirmActionHandler: (() -> Void)?
    
    @IBAction func OkClicked(_ sender: UIButton) {
        self.removeFromSuperview()
        self.OkActionHandler?()
    }
    @IBAction func confirmClicked(_ sender: Any) {
        self.removeFromSuperview()
        self.confirmActionHandler?()
    }
    @IBAction func cancelClicked(_ sender: Any) {
        self.removeFromSuperview()
        self.cancelActionHandler?()
    }
    
    func initWithConfiguration(configuration: PopUpConfiguration) {
        
        setAllUIColor(popupBackgroundColor: configuration.popUpBackgroundColor, titleBackgroundColor: configuration.titleBackGroundColor)
        
        setAllValues(title: configuration.titleString, description: configuration.descriptionString, alertOkText: configuration.okString, alertConfirmText: configuration.confirmString, alertCancelText: configuration.cancelString)
        
        setHideShowUI(showConfirm: configuration.showConfirm, showOk: configuration.showOk, showCancel: configuration.showCancel)
        
       // addGesture()
    }
    
   private func setAllUIColor(popupBackgroundColor: UIColor, titleBackgroundColor: UIColor) {
        self.popUpView.backgroundColor = popupBackgroundColor
        self.lblAccBlock.backgroundColor = titleBackgroundColor
    }
    
   private func setAllValues(title: String, description: String, alertOkText: String, alertConfirmText: String, alertCancelText: String) {
        self.lblAccBlock.text = title
        self.lblDesc.text = description
        self.btnOk.setTitle(alertOkText.uppercased(), for: .normal)
        self.btnCancel.setTitle(alertCancelText.uppercased(), for: .normal)
        self.btnConfirm.setTitle(alertConfirmText.uppercased(), for: .normal)
    }
    
    private func setHideShowUI(showConfirm: Bool, showOk: Bool, showCancel: Bool) {
        if showConfirm == true {
            btnConfirm.removeFromSuperview()
        }
        if showOk {
            btnOk.removeFromSuperview()
        }
        if showCancel {
            btnCancel.removeFromSuperview()
        }
    }
    
    private func addGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: .tapGestureActionForAlertPopUp)
        tapGesture.numberOfTapsRequired = 1
        tapGesture.delegate = self
        self.addGestureRecognizer(tapGesture)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
   
    @objc func tapGestureAction(sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
    
    deinit {
        print(" AlertPopUp deinit called")
    }
}
