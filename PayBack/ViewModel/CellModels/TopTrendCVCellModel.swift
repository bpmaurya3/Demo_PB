//
//  TopTrendCVCellModel.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 9/12/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class TopTrendCVCellModel: NSObject {
    var isFeatured: Bool?
    var productImage: UIImage?
    var productTitle: String?
    var productPrice: String?
    var productDealPrice: String?
    var productEarnPoints: String?
    var imagePath: String?
    var productID: String?
    var partnerImage: String?
    var itemType: String?
    var appDeepLink: String?
    
    init(isFeatured: Bool, productImage: UIImage, productTitle: String, productPrice: String, productDealPrice: String, productEarnPoints: String, productID: String) {
        self.isFeatured = isFeatured
        self.productImage = productImage
        self.productTitle = productTitle
        self.productPrice = productPrice
        self.productDealPrice = productDealPrice
        self.productEarnPoints = productEarnPoints
        self.productID = productID
    }
    
    init(withRedeemProductItem item: RedeemProduct.Result) {
        if let name = item.name {
            self.productTitle = name
        }
        
        if let actualPoints = item.price?.actualPoints {
            self.productEarnPoints = String(actualPoints)
        }
        
        if let small = item.images?.medium {
            self.imagePath = RequestFactory.getFinalRewardsImageURL(urlString: small[0])
        }
        if let productID = item.productId {
            self.productID = productID
        }
    }
    
    init(withTopTrend item: TopTrend.Trending) {
        if let name = item.title {
            self.productTitle = name
        }
        if let actualPoints = item.pbStoreData?.totalPoints {
            self.productEarnPoints = String(actualPoints)
        }
        if let price = item.origPrice {
            self.productPrice = String(price)
        }
        if let finalPrice = item.finalPrice {
            self.productDealPrice = finalPrice
        }
        if let storeLogo = item.storeLogo {
            self.partnerImage = storeLogo
        }
        if let small = item.img {
            self.imagePath = small
        }
        if let productID = item.id {
            self.productID = productID
        }
        self.itemType = item.itemType
        self.appDeepLink = item.url
    }
}
