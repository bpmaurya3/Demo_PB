//
//  DesignableNav.swift
//  PayBack
//
//  Created by Mohsin Surani on 09/11/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class DesignableNav: UIView {
    
    var titleLabel: UILabel!
    var backButton = UIButton()
    fileprivate var backButtonClosure: () -> Void = { }
    var isAddedInMyProfile = false

    @IBInspectable var title: String = "" { // set textfield corner radius
        didSet {
           self.titleLabel.text = title.uppercased()
        }
    }
    
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
    
    fileprivate func baseInit() {
        self.backgroundColor = ColorConstant.backgroudColorBlue
        
        backButton = UIButton()
        backButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        backButton.addTarget(self, action: .backClickedForDesignableNav, for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(backButton)
        
        titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 2
        //titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.font = FontBook.Roboto.ofTitleSize()
        titleLabel.minimumScaleFactor = 0.7
        self.addSubview(titleLabel)
        
       // self.heightAnchor.constraint(equalToConstant: 49).isActive = true

        backButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        backButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        let titleLeftConstraint = titleLabel.leftAnchor.constraint(equalTo: backButton.rightAnchor, constant: 5)
        titleLeftConstraint.priority = .init(1000)
        titleLeftConstraint.isActive = true
        
        let titleRightConstraint = titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10)
        titleRightConstraint.priority = .init(999)
        titleRightConstraint.isActive = true
        
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
    }
    
    @objc func backClicked() {
        guard isAddedInMyProfile else {
            self.parentViewController?.navigationController?.popViewController(animated: true)
            return
        }
        self.backButtonClosure()
    }
    
    @discardableResult
    func onBack(back: @escaping () -> Void) -> Self {
        self.backButtonClosure = back
        return self
    }
}
