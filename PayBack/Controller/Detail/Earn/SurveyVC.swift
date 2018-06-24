//
//  SurveyVC.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 9/16/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class SurveyVC: BaseViewController {
   
    @IBOutlet weak private var navigationView: DesignableNav!
    @IBOutlet weak private var headerHeight: NSLayoutConstraint!
    @IBOutlet weak private var mSurveyImageView: UIImageView!
    
    @IBOutlet weak private var startsurvetbtn: DesignableButton!
    @IBOutlet weak private var message: UILabel!
    @IBOutlet weak private var headerLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationView.title = "Take Surveys"
        self.startsurvetbtn.backgroundColor = ColorConstant.buttonBackgroundColorPink
        self.startsurvetbtn.titleLabel?.textColor = ColorConstant.textColorWhite
        self.startsurvetbtn.titleLabel?.font = FontBook.Regular.of(size: 17)
        
        self.message.textColor = ColorConstant.couponPopupInstructionTextColor
        self.message.font = FontBook.Regular.of(size: 12)
        
        self.headerLabel.textColor = ColorConstant.textColorPointTitle
        self.headerLabel.font = FontBook.Bold.of(size: 15)
        
    }
    
    deinit {
        print("Deinit - SurveyVC")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startSurveyButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
