//
//  Coupons.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 5/25/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import Foundation

struct Coupons: Decodable {
    let latestCoupons: [LatestCoupons]?
    let latestCouponCount: Int?
    
    struct LatestCoupons: Decodable {
        let storeName: String?
        let couponTitle: String?
        let couponDescription: String?
        let couponCode: String?
        let storeurl: String?
        let storeLogo: String?
        let pbstoreData: PbstoreData?
    }
    
    struct PbstoreData: Decodable {
        let pointText: String?
        let termsAndConditions: String?
    }
}
