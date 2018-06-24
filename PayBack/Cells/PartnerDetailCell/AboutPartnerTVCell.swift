//
//  AboutItemCell.swift
//  PayBack
//
//  Created by Dinakaran M on 07/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class AboutPartnerTVCell: UITableViewCell {
    
    var earnPointsClosure: () -> Void = {  }
    var videoClosure: () -> Void = {  }

    @IBOutlet weak private var discreption: UILabel!
    @IBOutlet weak private var aboutLabel: UILabel!
    @IBOutlet weak fileprivate var logoImage: UIImageView!
    
    @IBOutlet weak private var linkbutton: UIButton!
    @IBOutlet weak private var earnbutton: UIButton!
    @IBOutlet weak private var earnButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var linkButtonHeightConstraint: NSLayoutConstraint!
    
    var aboutItemCell: AboutItemCellModel? {
        didSet {
            guard let model = aboutItemCell else {
                return
            }
            self.parseData(forAboutItems: model)
        }
    }
    func parseData(forAboutItems aboutData: AboutItemCellModel) {
        if let linkMsg = aboutData.linkAccountMessage, !linkMsg.isEmpty {
            self.linkbutton.setTitle(linkMsg, for: .normal)
            earnButtonHeightConstraint.constant = 49
        } else {
            linkButtonHeightConstraint.constant = 0
        }
        if let earnMsg = aboutData.earnPointMessage, !earnMsg.isEmpty {
            self.earnbutton.setTitle(earnMsg, for: .normal)
            earnButtonHeightConstraint.constant = 40
        } else {
            earnButtonHeightConstraint.constant = 0
        }
        if let image = aboutData.logoUrl {
            self.logoImage.downloadImageFromUrl(urlString: image)
        }
        if let aboutMsg = aboutData.discreption {
            self.discreption.text = aboutMsg
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setFontsColors()
    }
    
    private func setFontsColors() {
        discreption.font = FontBook.Regular.of(size: 11)
        aboutLabel.font = FontBook.Bold.of(size: 18)
        linkbutton.titleLabel?.font = FontBook.Regular.of(size: 18)
        earnbutton.titleLabel?.font = FontBook.Regular.of(size: 18)
    }
    @IBAction func EarnButtonAction(_ sender: Any) {
        print("Clicked earn")
        earnPointsClosure()
    }
    
    @IBAction func LinkButtonAction(_ sender: Any) {
        print("Clicked Link")
        videoClosure()
    }
}

class AboutItemCellModel: NSObject {
    var logoUrl: String?
    var discreption: String?
    var earnPointMessage: String?
    var earnPointLinkUrl: String?
    var linkAccountMessage: String?
    var videoLinkUrl: String?
    
    internal init(logoUrl: String?, discreption: String?, earnPointMsg: String?, earnPointLinkUrl: String?, linkAccountMsg: String?, videoLinkUrl: String?) {
        self.logoUrl = logoUrl
        self.discreption = discreption
        self.earnPointMessage = earnPointMsg
        self.linkAccountMessage = linkAccountMsg
        self.earnPointLinkUrl = earnPointLinkUrl
        self.videoLinkUrl = videoLinkUrl
    }
    override init() {
        super.init()
    }
}
