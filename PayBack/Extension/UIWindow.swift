//
//  UIWindow.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 2/22/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import Foundation

extension UIWindow {
    var activityIndicatorTag: Int { return 999999 }
    func startActivityIndicator(
        style: UIActivityIndicatorViewStyle = .whiteLarge,
        location: CGPoint? = nil) {
        //stopActivityIndicator()
        DispatchQueue.main.async {
            let loc = location ?? self.center
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: style)
            activityIndicator.center = loc
            activityIndicator.tag = self.activityIndicatorTag
            activityIndicator.hidesWhenStopped = true
            activityIndicator.color = .black
            self.isUserInteractionEnabled = false
            activityIndicator.startAnimating()
            self.addSubview(activityIndicator)
            self.bringSubview(toFront: activityIndicator)
        }
    }
    func stopActivityIndicator() {
        DispatchQueue.main.async {
            if let activityIndicator = self.subviews.first(where: { $0.tag == self.activityIndicatorTag }) as? UIActivityIndicatorView {
                activityIndicator.stopAnimating()
                self.isUserInteractionEnabled = true
                activityIndicator.removeFromSuperview()
            }
        }
    }
}
