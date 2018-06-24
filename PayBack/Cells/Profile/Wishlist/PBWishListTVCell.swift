//
//  PBWishListTVCell.swift
//  PayBack
//
//  Created by valtechadmin on 01/10/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class PBWishListTVCell: UITableViewCell {
    
    var wishListCellModel: WishListCellModel? {
        didSet {
            guard let model = wishListCellModel else {
                return
            }
            self.parseData(forWishListCellData: model)
        }
    }
    
    @IBOutlet weak fileprivate var mProductImage: UIImageView!
    @IBOutlet weak fileprivate var mProductName: UILabel!
    @IBOutlet weak fileprivate var mItemCode: UILabel!
    @IBOutlet weak fileprivate var mProductPrice: UILabel!
    @IBOutlet weak fileprivate var remainingPointView: UIView!
    @IBOutlet weak fileprivate var remainingPointLabel: UILabel!
    @IBOutlet weak private var addToCartButton: DesignableButton!
    @IBOutlet weak fileprivate var pointsView: SwitchView!
    @IBOutlet weak private var deleteButton: UIButton!
    
    var wishListLandingType: ProductType = .none
    
    var deleteCellHandler: ((WishListCellModel) -> Void )?
    var shareHandler: ((WishListCellModel, UIButton) -> Void )?
    var cartOrBuyHandler: ((WishListCellModel, ProductType) -> Void )?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func addToCartAction(_ sender: Any) {
        guard let handler = cartOrBuyHandler, let model = wishListCellModel else {
           return
        }
        handler(model, wishListLandingType)
    }
    fileprivate func setUIElementBasedOnPoints(_ totalPoints: Int, _ points: Int, _ wishListCellData: WishListCellModel) {
        if totalPoints > points {
            if let productPrice = wishListCellData.mProductPrice {
                if wishListCellData.prodyctType == "Rewards" {
                    self.pointsView.titleLable.text = productPrice
                    pointsView.isHidden = false
                } else {
                    self.mProductPrice.text = "\(StringConstant.rsSymbol) \(productPrice)"
                    pointsView.isHidden = true
                }
            }
            remainingPointLabel.isHidden = true
            
            addToCartButton.isHidden = !remainingPointLabel.isHidden
            mProductPrice.isHidden = addToCartButton.isHidden
            addToCartButton.setTitle("Redeem", for: .normal)
        } else {
            remainingPointLabel.isHidden = false
            pointsView.isHidden = remainingPointLabel.isHidden
            
            addToCartButton.isHidden = !remainingPointLabel.isHidden
            mProductPrice.isHidden = addToCartButton.isHidden
            
            let remainingPoint = points - totalPoints
            self.remainingPointLabel.attributedText = .getAttributedTextforPointAway(changingValues: "\(remainingPoint)")
            if let productPoints = wishListCellData.mProductPrice {
                self.pointsView.titleLable.text = productPoints
            }
        }
    }
    
    private func parseData(forWishListCellData wishListCellData: WishListCellModel) {
        if let productImage = wishListCellData.mProductImage {
            self.mProductImage.image = productImage
        }
        if let productName = wishListCellData.mProductName {
            self.mProductName.text = productName
        }
        if let itemCode = wishListCellData.mItemCode {
            self.mItemCode.text = "Item Code: \(itemCode)"
        }
        if let imagePath = wishListCellData.imagePath {
            self.mProductImage.downloadImageFromUrl(urlString: imagePath)
        } else {
            self.mProductImage.image = #imageLiteral(resourceName: "placeholder")
        }
        
        guard wishListCellData.prodyctType == "Rewards" else {
            if let productPrice = wishListCellData.mProductPrice {
                self.mProductPrice.text = "\(StringConstant.rsSymbol) \(productPrice)"
            }
            remainingPointLabel.isHidden = true
            pointsView.isHidden = remainingPointLabel.isHidden
            
            addToCartButton.isHidden = !remainingPointLabel.isHidden
            mProductPrice.isHidden = addToCartButton.isHidden
            addToCartButton.setTitle("BUY NOW", for: .normal)
            return
        }
        
        guard let productPoints = wishListCellData.mProductPrice, let points = Int(productPoints), let userTotalPoint = UserProfileUtilities.getUserDetails()?.TotalPoints, let totalPoints = Int(userTotalPoint) else {
            return
        }
        setUIElementBasedOnPoints(totalPoints, points, wishListCellData)
    }
    
    @IBAction func deleteButtonAction(_ sender: UIButton) {
        guard let handler = deleteCellHandler, let model = wishListCellModel else {
            return
        }
        handler(model)
    }
    
    @IBAction func shareButtonAction(_ sender: UIButton) {
        guard let handler = shareHandler, let model = wishListCellModel else {
            return
        }
        handler(model, sender)
    }
    
}

internal class WishListCellModel: NSObject {
    var prodyctType: String?
    var mProductImage: UIImage?
    var mProductName: String?
    var mItemCode: String?
    var mProductPrice: String?
    var remainingPointLabel: String?
    var productPoints: String?
    var imagePath: String?
    var productId: String?
    var storeLogo: String?
    var storeLink: String?
    var wishlistId: String?
    var skuCode: String?

    internal init(mProductImage: UIImage, mProductName: String, mItemCode: String, mProductPrice: String, remainingPointLabel: String, points: String) {
        self.mProductImage = mProductImage
        self.mProductName = mProductName
        self.mItemCode = mItemCode
        self.mProductPrice = mProductPrice
        self.remainingPointLabel = remainingPointLabel
        self.productPoints = points
    }
    init(withWishListModel model: WishListModel.Result) {
        self.skuCode = model.skuCode
        self.wishlistId = model.wishlistId
        self.prodyctType = model.type
        self.productId = model.productId
        self.imagePath = model.productImage
        self.mProductName = model.productName
        self.mItemCode = model.productId?.uppercased()
        if let finalPrice = model.totalprice {
            self.mProductPrice = "\(finalPrice)"
        }
        self.remainingPointLabel = ""
        if let totalPoints = model.pbstore_data?.totalPoints {
            self.productPoints = "\(totalPoints)"
        }
        self.storeLogo = model.storeLogo
        self.storeLink = model.storeLink
    }
}
