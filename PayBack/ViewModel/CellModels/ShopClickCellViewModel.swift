//
//  ShopClickCellViewModel.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 10/12/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

internal class ShopClickCellViewModel: NSObject {
    var id: String?
    var image: UIImage?
    var title: String?
    
    var imagePath: String?
    
    // Insurance
    var filterTag: String?
    var redirectionURL: String?
    
    internal init(image: UIImage, earnInfo: String) {
        self.image = image
        self.title = earnInfo
    }
    
    internal init(forInsurance image: UIImage) {
        self.image = image
    }
    
    internal init(forSignUp image: UIImage?, url: String?, title: String?) {
        self.image = image
        self.redirectionURL = url
        self.title = title
    }
    
    init(withRewardCategories category: Categories.RewardsCategory) {
        self.id = category.id
        self.title = category.name
        self.imagePath = category.iconUrl
    }
    init(withShopOnlineCategories category: Categories.Category) {
        self.id = category.id
        self.title = category.name
        self.imagePath = category.iconURL
    }
    
    init(withInsuranceTypes type: InsuranceTypes.IconGridView) {
        self.title = type.title
        self.imagePath = type.imagePath
        self.filterTag = type.filterTags
    }
    
    init(withParners type: OtherPartner.PartnerDetails) {
        self.title = type.description
        self.imagePath = type.logoImage
    }
    init(withSignupGrid type: SignupImageGridModel.ImageGridWithTitle.ImageGridDetails) {
        self.title = type.imagegridtitle
        self.imagePath = type.imagePath
    }
    init(withSignupParners type: OtherPartner.PartnerDetails) {
        self.imagePath = type.logoImage
    }
}
