//
//  HeroBanner.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 9/20/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

/* enable when json decoder will be stable : @available Swift 4.0*/
struct HeroBanner: Decodable {
    let errorCode: String?
    let errorMessage: String?
   
    let banneImageObj: BannerImage?
    let heroBannerDetails: HeroBannerDetails?
    let partnerPlacardDetails: PlaCardDetails?
    
    struct HeroBannerDetails: Decodable {
        let title: String?
        let subTitle: String?
        let imagePath: String?
        let redirectionPartnerLogo: String?
        let expiryTime: String?
        let startTime: String?
        let expired: Bool?
    }
    
    struct BannerImage: Decodable {
        let bannerImage: String?
        let redirectionalURL: String?
        let redirectionPartnerLogo: String?
        let expired: Bool?
        let expiryTime: String?
        let startTime: String?
        let admob: Bool?
        let adUnitId: String?
    }
    
    struct PlaCardDetails: Decodable {
        let title: String?
        let subTitle: String?
        let imagePath: String?
        let redirectionalURL: String?
        let redirectionPartnerLogo: String?
        let termsAndConditions: String?
        let expired: Bool?
        let expiryTime: String?
        let startTime: String?
        let admob: Bool?
        let adUnitId: String?
    }
}

/*
struct HeroBanner {
    private let data: [String: Any]
    
    var title: String? {
        return  data["title"] as? String
    }
    var subTitle: String? {
        return  data["subTitle"] as? String
    }
    
    var imagePath: String? {
        return  data["imagePath"] as? String
    }
    var imageLOGOPath: String? {
        return data["imageLOGOPath"] as? String
    }
    
    init(fromData data: [String: Any]) {
        self.data = data
    }
}
*/
