//
//  RateUsVC.swift
//  PayBack
//
//  Created by Dinakaran M on 18/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class RateUsVC: BaseViewController {

    @IBOutlet weak private var feedbackLabel: UILabel!
    @IBOutlet weak private var loveAppLabel: UILabel!
    @IBOutlet weak private var helpLabel: UILabel!

    @IBOutlet weak private var rateNowButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setFontsColors()
    }

    private func setFontsColors() {
        feedbackLabel.font = FontBook.Bold.of(size: 20)
        feedbackLabel.textColor = ColorConstant.textColorBlack
        rateNowButton.backgroundColor = ColorConstant.buttonBackgroundColorPink
        rateNowButton.titleLabel?.font = FontBook.Regular.of(size: 15)
        loveAppLabel.font = FontBook.Medium.of(size: 15)
        loveAppLabel.textColor = ColorConstant.textColorBlack
        helpLabel.font = FontBook.Medium.of(size: 12)
        helpLabel.textColor = ColorConstant.textColorBlack
    }
    
    @IBAction func rateUsButtonAction(_ sender: UIButton) {
        UIApplication.shared.openURL(URL(string: "https://itunes.apple.com/in/app/payback-india/id961049647?mt=8")!)
    }
    
}
