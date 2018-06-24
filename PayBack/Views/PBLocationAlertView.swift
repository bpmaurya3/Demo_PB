//
//  PBLocationAlertView.swift
//  PayBack
//
//  Created by Sudhansh Gupta on 16/05/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import UIKit

class PBLocationAlertView: UIView {

    @IBOutlet weak var messageLabel: UILabel!
    
    var okButtonClouser: (() -> Void) = { }
    var cancelButtonClouser: (() -> Void) = { }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        cancelButtonClouser()
    }
    
    @IBAction func okButtonAction(_ sender: UIButton) {
        okButtonClouser()
    }
}
