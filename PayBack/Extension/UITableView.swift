//
//  UITableView.swift
//  PayBack
//
//  Created by Mohsin Surani on 26/10/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

extension UITableView {
    func addTapGestureForEndEditing() {
        let tapGesture = UITapGestureRecognizer(target: self, action: .hideKeyboardForUITableView)
        tapGesture.cancelsTouchesInView = true
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        self.endEditing(false)
    }
    
    func updateTableView(animation: Bool) {
        if animation {
            self.beginUpdates()
            self.endUpdates()
        } else {
            UIView.performWithoutAnimation {
                self.beginUpdates()
                self.endUpdates()
            }
        }
    }
}
