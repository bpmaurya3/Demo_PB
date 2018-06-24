//
//  ProductListCellModel.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 10/16/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

final internal class ProductListCellModel: NSObject {
    var productImg: UIImage?
    var productFeaturedTag: Bool?
    var productAvailable: String?
    var productPoints: String?
    var productPrize: String?
    var productOffer: String?
    var productDiscout: String?
    var productName: String?
    var productImagePath: String?
    var productID: String?
    var itemType: String?
    var appDeepLink: String?
    var storeLogo: String?
    
    internal init(pImage: String? = nil, pFeatureTag: Bool = false, pAvailable: String?=nil, pPoints: String?=nil, pPrize: String?=nil, pOffer: String?=nil, pDiscount: String?=nil, pName: String?=nil) {
        if let img = pImage {
            self.productImg = UIImage(named: img)
        }
        self.productFeaturedTag = pFeatureTag
        self.productAvailable = pAvailable
        self.productPoints = pPoints
        self.productPrize = pPrize
        self.productOffer = pOffer
        self.productDiscout = pDiscount
        self.productName = pName
    }
    
    internal init(withTopTrendData trending: TopTrend.Trending) {
        if let name = trending.title {
            self.productName = name
        }
        if let points = trending.pbStoreData?.totalPoints {
            self.productPoints = String(points)
        }
        if let small = trending.img {
            self.productImagePath = small
        }
        if let origPrice = trending.origPrice {
            self.productPrize = String(origPrice)
        }
        if let finalPrice = trending.finalPrice {
            self.productDiscout = String(finalPrice)
        }
        if let productID = trending.id {
            self.productID = productID
        }
        if let discountValue = trending.discount {
            self.productOffer = String(discountValue) + "% off"
        }
        if let numInstockStores = trending.instock {
            self.productAvailable = "Available from \(numInstockStores) sellers"
        }
        self.itemType = trending.itemType
        self.appDeepLink = trending.url
        self.storeLogo = trending.storeLogo
    }
    internal init(withCategoryProductData category: CategoryProduct.CategoryProducts) {
        if let name = category.title {
            self.productName = name
        }
        if let points = category.pbStoreData?.totalPoints {
            self.productPoints = String(points)
        }
        if let small = category.img {
            self.productImagePath = small
        }
        if let origPrice = category.origPrice {
            self.productPrize = "\(origPrice)"
        }
        if let finalPrice = category.finalPrice {
            self.productDiscout = "\(finalPrice)"
        }
        if let productID = category.id {
            self.productID = productID
        }
        if let discountValue = category.discountVal {
            self.productOffer = String(discountValue) + "% off"
        }
        if let numInstockStores = category.numInstockStores {
            self.productAvailable = "Available from \(numInstockStores) sellers"
        }
        self.itemType = category.itemType
        self.appDeepLink = category.url
        self.storeLogo = category.storeLogo
    }
    
    internal init(withBurnSearchData searchItem: RedeemProduct.Result) {
        
        if let name = searchItem.name {
            self.productName = name
        }
        
        if let actualPoints = searchItem.price?.actualPoints {
            self.productPoints = String(actualPoints)
        }
        
        if let small = searchItem.images?.medium {
            self.productImagePath = RequestFactory.getFinalRewardsImageURL(urlString: small[0])
        }
        if let productID = searchItem.productId {
            self.productID = productID
        }
        
    }
}
