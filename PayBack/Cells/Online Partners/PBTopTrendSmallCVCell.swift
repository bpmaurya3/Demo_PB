//
//  PBTopTrendSmallCVCell.swift
//  PayBack
//
//  Created by Sudhansh Gupta on 11/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class PBTopTrendSmallCVCell: UICollectionViewCell {
    
    @IBOutlet weak private var mEarnPointView: SwitchView!
    @IBOutlet weak private var mActualPrice: UILabel!
    @IBOutlet weak private var mProductName: UILabel!
    @IBOutlet weak private var mPartnerImage: UIImageView!
    @IBOutlet weak private var mProductImage: UIImageView!

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
        mProductName.font = FontBook.Bold.of(size: 12)
        mEarnPointView.titleLable.font = FontBook.Medium.of(size: 12)
    }
    
    deinit {
        print("PBTopTrendSmallCVCell: deinit called")
    }
    
    private func parseData(forbestTopTrendCellData cellModel: TopTrendCVCellModel) {
        
        if let storeLogo = cellModel.partnerImage {
            mPartnerImage.downloadImageFromUrl(urlString: storeLogo)
        }
        if let productImage = cellModel.productImage {
            mProductImage.image = productImage
        }
        if let productName = cellModel.productTitle {
            mProductName.text = productName
        }
        if let productPrice = cellModel.productPrice {
            mActualPrice.attributedText = Utilities.getTextWithStickLine(string: "\(StringConstant.rsSymbol) \(productPrice)") //productPrice
        }
        if let dealPrice = cellModel.productDealPrice {
            let dealPrice = Utilities.getTextWithColor(color: ColorConstant.textColorRed, text: "  \(StringConstant.rsSymbol) \(dealPrice)")
            
            let combination = NSMutableAttributedString()
            combination.append(mActualPrice.attributedText ?? NSAttributedString())
            combination.append(dealPrice)
            mActualPrice.attributedText = combination
        }
        if let earnPoints = cellModel.productEarnPoints {
            mEarnPointView.titleLable.text = earnPoints
        }
        
        if let imageUrl = cellModel.imagePath {
            self.mProductImage.downloadImageFromUrl(urlString: imageUrl)
        }
        
    }
}
