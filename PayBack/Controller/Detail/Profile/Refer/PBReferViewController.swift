//
//  PBReferViewController.swift
//  PayBack
//
//  Created by valtechadmin on 17/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class PBReferViewController: BaseViewController {
    
    @IBOutlet weak private var navigationView: DesignableNav!
    @IBOutlet weak private var mReferCodeLabel: UILabel!
    @IBOutlet weak fileprivate var topTitleLabel: UILabel!
    @IBOutlet weak fileprivate var descriptionLabel: UILabel!
    @IBOutlet weak fileprivate var referalCodeTitleLabel: UILabel!
    @IBOutlet weak fileprivate var shareViaTitleLabel: UILabel!
    @IBOutlet weak fileprivate var copyLinkButton: UIButton!
    @IBOutlet weak fileprivate var shareButton: DesignableButton!
    
    var homeViewController: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    @IBAction func copyLinkButtonAction(_ sender: UIButton) {
        if let copyCode = mReferCodeLabel.text {
            copyCode.copyAction()
            sender.setTitle("Copied", for: .normal)
            sender.isUserInteractionEnabled = false
        }
    }
    deinit {
        print("Deinit called - PBReferViewController")
    }
    @IBAction func shareButtonAction(_ sender: UIButton) {
        let text = mReferCodeLabel.text
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: [textToShare as Any], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = sender

        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook, UIActivityType.mail ]
        self.present(activityViewController, animated: true, completion: nil)
    }
}
extension PBReferViewController {
    fileprivate func setup() {
        mReferCodeLabel.textColor = ColorConstant.textColorPointTitle
        mReferCodeLabel.font = FontBook.Regular.of(size: 12)
        topTitleLabel.font = FontBook.Bold.of(size: 18)
        topTitleLabel.textColor = ColorConstant.headerTextColorPoint
        descriptionLabel.font = FontBook.Regular.of(size: 14)
        descriptionLabel.textColor = ColorConstant.headerTextColorPoint
        referalCodeTitleLabel.textColor = ColorConstant.headerTextColorPoint
        referalCodeTitleLabel.font = FontBook.Bold.of(size: 18)
        shareViaTitleLabel.textColor = ColorConstant.headerTextColorPoint
        shareViaTitleLabel.font = FontBook.Bold.of(size: 18)
        copyLinkButton.backgroundColor = ColorConstant.referFriendButtonBGColor
        copyLinkButton.titleLabel?.font = FontBook.Medium.of(size: 12)
        shareButton.backgroundColor = ColorConstant.referFriendButtonBGColor
        shareButton.titleLabel?.font = FontBook.Medium.of(size: 12)
    }
}
