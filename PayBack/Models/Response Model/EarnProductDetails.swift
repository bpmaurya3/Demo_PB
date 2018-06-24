//
//  EarnProductDetails.swift
//  PayBack
//
//  Created by Dinakaran M on 02/11/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

struct EarnProductDetails: Codable {
    let results: [Results]?
    let couponsinfo: Couponsinfo?
    let metaInfo: MetaInfo?
    let reviews: Reviews?
    let featureAttribute: [FeatureAttribute]?
    struct SeoInfo: Codable {
    }
    struct Results: Codable {
        let price: Double?
        let origPrice: Float?
        let cashback: Double?
        let finalPrice: Float?
        let discountVal: Int?
        let url: String?
        let instock: Double?
        let title: String?
        let desc: String?
        let img: String?
        let brand: String?
        let noun: String?
        let updatedTime: Double?
        let canonUrl: String?
        let type: Double?
        let source: Double?
        let sourceRank: Double?
        let store: String?
        let featured: Double?
        let rating: Double?
        let numrating: Double?
        let autoVerified: Double?
        let cod: Bool?
        let storefulfilled: Bool?
        let isLowestStoreColor: Bool?
        let breadcrumb: [String]?
        let shippingcharge: Double?
        let homeRedirect: Double?
        let specDownloaded: Double?
        let storeLogo: String?
        let imageVariants: [String]?
        let pbStoreData: PbstoreData?
    }
    struct Couponsinfo: Codable {
        let title: String?
        let coupons: [String: [Inner]]?
    }
    struct Inner: Codable {
        let couponCode: String?
        let couponDescription: String?
    }
    struct MetaInfo: Codable {
        let id: String?
        let title: String?
        let origPrice: Double?
        let finalPrice: Double?
        let discountVal: Int?
        let img: String?
        let url: String?
        let imageVariants: [String]?
        let storeLink: String?
        let appDeepLink: String?
        let returndays: String?
        let shippingtime: String?
        let pbstore_data: PbstoreData?
        let storeLogo: String?
        let store: String?
        let shareUrl: String?
    }
    struct PbstoreData: Codable {
        let partnerShortDescription: String?
        let termsAndConditions: String?
        let pointText: String?
        let pointsPerStore: String?
        let isBonusCouponExist: Int?
        let totalPoints: Int?

    }
    struct Reviews: Codable {
        let productid: String?
        let reviews: [String: [SubReviews]]?
        let errors: [Errors]?
    }
    struct Errors: Codable {
        let id: Int?
        let error: String?
    }
    struct SubReviews: Codable {
        let text: String?
        let title: String?
        let created: String?
        let author: String?
        let rating: Int?
    }
}
struct FeatureAttribute: Codable {
    let name: String?
    let value: String?
}
