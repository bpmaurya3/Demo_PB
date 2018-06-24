//
//  UIView.swift
//  PayBack
//
//  Created by Mohsin Surani on 09/11/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    func errorMsgView(errorMsg: String = "Invalid Error") {
        DispatchQueue.main.async {
            let errorView = UINib(nibName: "ErrorInfoView", bundle: nil).instantiate(withOwner: self, options: nil).first as? ErrorInfoView
            errorView?
                .set(viewHeight: 50)
                .set(errorViewBottomSpace: 0)
                .set(selfView: (self))
                .set(errorMessage: errorMsg)
                .set(animationDuration: 0.2)
                .set(showErrorView: true)
        }
    }
    
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}
