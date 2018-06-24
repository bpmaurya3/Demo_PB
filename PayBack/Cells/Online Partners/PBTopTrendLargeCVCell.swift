//
//  PBTopTrendLargeCVCell.swift
//  PayBack
//
//  Created by Sudhansh Gupta on 11/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class PBTopTrendLargeCVCell: UICollectionViewCell {
    
    @IBOutlet weak private var mEarnPointView: SwitchView!
    @IBOutlet weak private var mActualPrice: UILabel!
    @IBOutlet weak private var mProductName: UILabel!
    @IBOutlet weak private var mPartnerImgView: UIImageView!
    @IBOutlet weak private var mProductImgView: UIImageView!
    @IBOutlet weak private var priceViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var partnerImageHeightConstraint: NSLayoutConstraint!
    var cellModel: TopTrendCVCellModel? {
        didSet {
            guard let cellModel = cellModel else {
                return
            }
            self.parseData(forbestTopTrendCellData: cellModel)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.priceViewHeightConstraint.constant = 0
        self.partnerImageHeightConstraint.constant = 0
        self.mActualPrice.isHidden = true
        self.mPartnerImgView.isHidden = true
        self.mProductImgView.contentMode = .scaleAspectFit
        
        mProductName.font = FontBook.Bold.of(size: 12)
        mEarnPointView.titleLable.font = FontBook.Medium.of(size: 13)
    }
    
    deinit {
        print("PBTopTrendLargeCVCell: deinit called")
    }
    
    private func parseData(forbestTopTrendCellData cellModel: TopTrendCVCellModel) {
        
        if let isFeatured = cellModel.isFeatured, isFeatured {
            mPartnerImgView.image = #imageLiteral(resourceName: "Sample_3")
            mPartnerImgView.isHidden = false
            self.partnerImageHeightConstraint.constant = 50
        } else if let partnerImage = cellModel.partnerImage {
            mPartnerImgView.downloadImageFromUrl(urlString: partnerImage)
            mPartnerImgView.isHidden = false
            self.partnerImageHeightConstraint.constant = 50
        }
        if let title = cellModel.productTitle {
            self.mProductName.text = title
        }
        if let productImage = cellModel.productImage {
            mProductImgView.image = productImage
        }
        if cellModel.productPrice != nil || cellModel.productDealPrice != nil {
            self.priceViewHeightConstraint.constant = 20
        }
        if let productPrice = cellModel.productPrice {
            mActualPrice.attributedText = Utilities.getTextWithStickLine(string: "\(StringConstant.rsSymbol) \(productPrice)")
            mActualPrice.isHidden = false
        }
        if let dealPrice = cellModel.productDealPrice {
            let dealPrice = Utilities.getTextWithColor(color: ColorConstant.textColorRed, text: "  \(StringConstant.rsSymbol) \(dealPrice)")
            
            let combination = NSMutableAttributedString()
            combination.append(mActualPrice.attributedText ?? NSAttributedString())
            combination.append(dealPrice)
            mActualPrice.attributedText = combination
            mActualPrice.isHidden = false
        }
        if let earnPoints = cellModel.productEarnPoints {
            mEarnPointView.titleLable.text = earnPoints
        }
        if let imageUrl = cellModel.imagePath {
            self.mProductImgView.downloadImageFromUrl(urlString: imageUrl)
        }
    }

}
