//
//  SegmentCollectionViewCellModel.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 10/31/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class SegmentCollectionViewCellModel {
    var image: UIImage?
    var selectedImage: UIImage?
    var title: String?
    var itemId: String?
    
    var imagePath: String?
    
    init(image: UIImage? = nil, title: String? = nil, itemId: Int, selectedImage: UIImage? = nil) {
        if let img = image {
            self.image = img
        }
        if let img = selectedImage {
            self.selectedImage = img
        }
        self.title = title
        self.itemId = "\(itemId)"
    }
    init(title: String) {
        self.title = title
        self.itemId = title
    }
    init(withCouponsCategory category: String) {
        self.title = category
        self.itemId = category
    }
    init(withInstoreOffersCategory category: OfferMenuItems.Category) {
        self.title = category.tagTitle
        self.itemId = category.tagID
    }
    init(withRechargeCategory category: OfferMenuItems.Category) {
        self.title = category.tagTitle
        self.itemId = category.tagID
    }
    
    init(withInsuranceSubTypes item: InsuranceTypes.TagImageGridElement) {
        self.title = item.title
        self.imagePath = item.imagePath
        self.itemId = item.ownTag
    }
    init(withOnlineOffersFilters item: String) {
        self.title = item
        self.itemId = item
    }
}
