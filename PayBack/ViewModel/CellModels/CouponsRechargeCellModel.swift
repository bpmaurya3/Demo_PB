//
//  CouponsRechargeCellModel.swift
//  PayBack
//
//  Created by Valtech Macmini on 29/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class CouponsRechargeCellModel: NSObject {
    // common
    var thumbnailImage: UIImage?
    var title: String?
    var subTitle: String?
    var thumbnailPath: String?
    var redirectionUrl: String?
    var redirectionLogoPath: String?
    var termsAndCondition: String?
    var buttonText1: String?
    var buttonText2: String?
    var ctaButtonLink1: String?
    var ctaButtonLink2: String?
    
    // add on in online offers
    var partnerOffer: String?
    
    // add on in recharge
    var isFeatured: Bool?
    var promoCode: String?
    
    // Instore offers
    var storeDistance: String?
    var storeLocations: [Location]?
        
    init(instoreOffers offers: InstoreListModel.Deals) {
        self.title = offers.brand
        self.subTitle = offers.title
        self.thumbnailPath = offers.image
        self.redirectionUrl = offers.url
        self.redirectionLogoPath = offers.image
        self.termsAndCondition = offers.description
        self.storeLocations = offers.locations
        let distance = offers.distance?.rounded(toPlaces: 1)
        self.storeDistance = distance != 1.0 || distance != 0 ? "\(distance!) Kms" : "\(distance!) Km"
    }
    
    init(forRecharge recharge: CouponsRecharge.ResponseData) {
        self.title = recharge.gridImageTitle
        self.subTitle = recharge.gridImageSubtitle
        self.thumbnailPath = recharge.gridImagePath
        self.redirectionUrl = recharge.redirectionURL
        self.redirectionLogoPath = recharge.gridImagePath
        self.termsAndCondition = recharge.termsAndCondition
        self.buttonText1 = recharge.buttonText1
        self.buttonText2 = recharge.buttonText2
        self.ctaButtonLink1 = recharge.ctaButtonLink1
        self.ctaButtonLink2 = recharge.ctaButtonLink2
        
        if let promocode = recharge.promocode {
            self.promoCode = promocode
        }
    }
    init(forCouponData coupon: Coupons.LatestCoupons) {
        self.title = coupon.couponTitle
        self.subTitle = coupon.couponDescription
        self.thumbnailPath = coupon.storeLogo
        self.redirectionUrl = coupon.storeurl
        self.redirectionLogoPath = coupon.storeLogo
        self.termsAndCondition = coupon.pbstoreData?.termsAndConditions
//        self.buttonText1 = coupon.buttonText1
//        self.buttonText2 = coupon.buttonText2
//        self.ctaButtonLink1 = coupon.ctaButtonLink1
//        self.ctaButtonLink2 = coupon.ctaButtonLink2
        
        if let promocode = coupon.couponCode {
            self.promoCode = promocode
        }
    }
    init(forOnlineOffers offers: OnlineOffersModel.Results) {
        self.title = offers.store
        self.subTitle = "You can earn PAYBACK Points at " + (offers.store ?? "")
        self.thumbnailPath = offers.img
        self.redirectionUrl = offers.url
        self.redirectionLogoPath = offers.storeLogo
        self.termsAndCondition = offers.pbStoreData?.pointText
    }
    init(forInsurenceDetail thumbnailImage: UIImage, title: String, subTitle: String) {
        self.thumbnailImage = thumbnailImage
        self.title = title
        self.subTitle = subTitle
    }
    
    init(forOnlineOffers thumbnailImage: UIImage, title: String, subTitle: String, partnerOffer: String) {
        
        self.thumbnailImage = thumbnailImage
        self.title = title
        self.subTitle = subTitle
        self.partnerOffer = partnerOffer
    }
    
    init(forRecharge thumbnailImage: UIImage, title: String, subTitle: String, isFeatured: Bool, promoCode: String) {
        
        self.thumbnailImage = thumbnailImage
        self.title = title
        self.subTitle = subTitle
        self.isFeatured = isFeatured
        self.promoCode = promoCode
    }
    
}
