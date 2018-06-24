//
//  HomeLogo.swift
//  PayBack
//
//  Created by Dinakaran M on 19/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class HomeLogo: UIView {

    var logoTapClosure: () -> Void = {  }
    
    @IBOutlet weak fileprivate var widthconstraints: NSLayoutConstraint!
    @IBOutlet weak fileprivate var logobutton: UIButton!
    @IBOutlet weak fileprivate var homeLogo: UIImageView!
    
    @IBAction func clickLogo() {
        self.logoTapClosure()
    }
}

extension HomeLogo {
    @discardableResult
    func update(widthconstraints constant: CGFloat) -> Self {
        self.widthconstraints.constant = constant
        
        return self
    }
    
    @discardableResult
    func set(homeLogo image: UIImage) -> Self {
        self.homeLogo.image = image
        
        return self
    }
}
