//
//  ShowCaseCategoryCVCell.swift
//  PayBack
//
//  Created by Sudhansh Gupta on 11/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class ShowCaseCategoryCVCell: UICollectionViewCell {

    @IBOutlet weak private var mPartnerImage: UIImageView!
    @IBOutlet weak private var mEarnPointView: SwitchView!
    @IBOutlet weak private var mProductImage: UIImageView!
    @IBOutlet weak private var mActualPrice: UILabel!
    @IBOutlet weak private var mProductName: UILabel!
    
    var bestFashionCellViewModel: ShowCaseCategoryCellVM? {
        didSet {
            guard let cellModel = bestFashionCellViewModel else {
                return
            }
            self.parseData(forbestFashionCellData: cellModel)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    deinit {
        print("ShowCaseCategoryCVCell: deinit called")
    }
    
    private func parseData(forbestFashionCellData bestFashionCellViewModel: ShowCaseCategoryCellVM) {
        
        if let partnerImage = bestFashionCellViewModel.partnerImage {
            mPartnerImage.image = partnerImage
        }
        if let partnerImagePath = bestFashionCellViewModel.partnerImagePath {
            mPartnerImage.downloadImageFromUrl(urlString: partnerImagePath)
        } else {
            mPartnerImage.image = #imageLiteral(resourceName: "placeholder")
        }
        if let productImage = bestFashionCellViewModel.productImage {
            mProductImage.image = productImage
        }
        if let productImagePath = bestFashionCellViewModel.productImagePath {
            mProductImage.downloadImageFromUrl(urlString: productImagePath)
        } else {
            mProductImage.image = #imageLiteral(resourceName: "placeholder")
        }
        if let earnPoint = bestFashionCellViewModel.earnPoints {
            mEarnPointView.titleLable.text = earnPoint
        }
        if let productName = bestFashionCellViewModel.productName {
            mProductName.text = productName
        }
        if let actualPrice = bestFashionCellViewModel.actualPrice {
            mActualPrice.attributedText = Utilities.getTextWithStickLine(string: "\(StringConstant.rsSymbol) \(actualPrice)")
        }
        if let offerPrice = bestFashionCellViewModel.offerPrice {
            let dealPrice = Utilities.getTextWithColor(color: ColorConstant.textColorRed, text: "  \(StringConstant.rsSymbol) \(offerPrice)")
            
            let combination = NSMutableAttributedString()
            combination.append(mActualPrice.attributedText ?? NSAttributedString())
            combination.append(dealPrice)
            mActualPrice.attributedText = combination
        }
    }
}

internal class ShowCaseCategoryCellVM: BaseModel {
    var productImage: UIImage?
    var earnPoints: String?
    var partnerImage: UIImage?
    var offerPrice: String?
    var actualPrice: String?
    var productName: String?
    var productID: String?
    var productImagePath: String?
    var partnerImagePath: String?
    
    internal init(productImage: UIImage, productName: String, earnPoints: String, actualPrice: String, partnerImage: UIImage, offerPrice: String, productID: String) {
        self.productImage = productImage
        self.earnPoints = earnPoints
        self.partnerImage = partnerImage
        self.offerPrice = offerPrice
        self.actualPrice = actualPrice
        self.productName = productName
        self.productID = productID
    }
    override init() {
    }
    
    init(withBestFashion bestFashion: CategoryProduct.CategoryProducts) {
        self.productImagePath = bestFashion.img
        if let totalPoints = bestFashion.pbStoreData?.totalPoints {
             self.earnPoints = "\(totalPoints)"
        }
        self.partnerImagePath = bestFashion.storeLogo
        if let finalPrice = bestFashion.finalPrice {
            self.offerPrice = "\(finalPrice)"
        }
        if let origPrice = bestFashion.origPrice {
            self.actualPrice = "\(origPrice)"
        }
        self.productName = bestFashion.title
        self.productID = bestFashion.id
    }
}
