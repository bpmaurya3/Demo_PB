//
//  FeedBackAlertPopUp.swift
//  PaybackPopup
//
//  Created by Mohsin.Surani on 18/08/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class FeedBackAlertPopUp: UIView, UIGestureRecognizerDelegate {

    var rateNowHandler: (() -> Void )?
    var ratelaterActionHandler: (() -> Void )?
    
    func addGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: .tapGestureActionForFeedBackAlertPopUp)
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
    
    @IBAction func rateLaterClicked(_ sender: Any) {
        self.ratelaterActionHandler?()
    }
    
    @IBAction func rateAppClicked(_ sender: Any) {
        self.rateNowHandler?()
    }
    
    deinit {
        print(" FeedBackAlertPopUp deinit called")
    }
}
