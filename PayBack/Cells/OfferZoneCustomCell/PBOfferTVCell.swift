//
//  PBOffersCell.swift
//  PayBack
//
//  Created by Sudhansh Gupta on 05/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class PBOfferTVCell: UITableViewCell {
    
    var offerCellModel: CouponsRechargeCellModel? {
        didSet {
            guard let cellModel = offerCellModel else {
                return
            }
            self.parseData(forOfferCellData: cellModel)
        }
    }
    
    @IBOutlet weak private var partnerOffer: UILabel!
    @IBOutlet weak private var partnerInfo: UILabel!
    @IBOutlet weak private var partnerName: UILabel!
    @IBOutlet weak private var partnerImageView: UIImageView!
    @IBOutlet weak private var partnerImageContentView: UIView!
    @IBOutlet weak private var containerViewBottomContraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setUIFonts()
    }
    
    private func setUIFonts() {
        partnerName.font = FontBook.Bold.ofTVCellTitleSize()
        partnerName.textColor = ColorConstant.textColorBlack
        partnerInfo.font = FontBook.Regular.ofTVCellSubTitleSize()
        partnerInfo.textColor = ColorConstant.textColorGray
        partnerOffer.font = FontBook.Regular.ofTVCellSubTitleSize()
        partnerOffer.textColor = ColorConstant.textTitleColorPink

    }
    
    private func setupUI() {
        partnerImageContentView.layer.borderWidth = 0.5
        partnerImageContentView.layer.borderColor = ColorConstant.imageOfferBorderColor.cgColor
    }
    
    deinit {
        print(" PBOfferTVCell deinit called")
    }
    
    private func parseData(forOfferCellData offerCellData: CouponsRechargeCellModel) {
        if let image = offerCellData.thumbnailImage {
            self.partnerImageView.image = image
        } else {
            self.partnerImageView.image = #imageLiteral(resourceName: "placeholder")
        }
        if let partnerName = offerCellData.title {
            self.partnerName.text = partnerName
        } else {
            self.partnerName.text = ""
        }
        if let partnerInfo = offerCellData.subTitle {
            self.partnerInfo.text = partnerInfo
        } else {
            self.partnerInfo.text = ""
        }
        if let partnerOffer = offerCellData.termsAndCondition {
            self.partnerOffer.text = partnerOffer
        } else {
            self.partnerOffer.text = ""
        }
        
        if let imagePath = offerCellData.thumbnailPath {
            self.partnerImageView.downloadImageFromUrl(urlString: imagePath)
        }
        
    }
}
extension PBOfferTVCell {
    @discardableResult
    func update(containerBottomContraint constant: CGFloat) -> Self {
        self.containerViewBottomContraint.constant = constant
        
        return self
    }
}
