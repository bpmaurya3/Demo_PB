//
//  WishListModel.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 1/29/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import Foundation

struct WishListModel: Decodable {
    let wishListDetails: [Result]?
    
    struct Result: Decodable {
        let type: String?
        let productId: String?
        let productName: String?
        let origPrice: Int64?
        let finalPrice: Int64?
        let discountVal: Int?
        let productImage: String?
        let numInstockStores: Int?
        let numTotalStores: Int?
        let pbstore_data: PbstoreData?
        let storeLink: String?
        let storeLogo: String?
        let totalprice: String?
        let wishlistId: String?
        let skuCode: String?
    }
    struct PbstoreData: Decodable {
        let partnerShortDescription: String?
        let termsAndConditions: String?
        let pointText: String?
        let pointsPerStore: String?
        let isBonusCouponExist: Int
        let totalPoints: Int
    }
}
