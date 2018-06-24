//
//  HeroBannerCellModel.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 9/20/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

final internal class HeroBannerCellModel: BaseModel {
    var image: UIImage?
    
    var title: String?
    var subTitle: String?
    var imagePath: String?
    var redirectionURL: String?
    var redirectionPartnerLogo: String?
    var expired: Bool?
    var expiryTime: String?
    var startTime: String?
    var admob: Bool?
    var adUnitId: String?
    
    override init() {}
    
    internal init(image: UIImage) {
        self.image = image
    }
    internal init(imagePath: String) {
        self.imagePath = imagePath
    }
    internal init(withHeroBanner heroBanner: HeroBanner.HeroBannerDetails) {
        self.title = heroBanner.title
        self.subTitle = heroBanner.subTitle
        self.imagePath = heroBanner.imagePath
        self.redirectionPartnerLogo = heroBanner.redirectionPartnerLogo
        self.expired = heroBanner.expired
        self.expiryTime = heroBanner.expiryTime
        self.startTime = heroBanner.startTime
    }
    
    internal init(withPlacard heroBanner: HeroBanner.PlaCardDetails) {
        self.title = heroBanner.title
        self.subTitle = heroBanner.subTitle
        self.imagePath = heroBanner.imagePath
        self.redirectionPartnerLogo = heroBanner.redirectionPartnerLogo
        self.redirectionURL = heroBanner.redirectionalURL
        self.expired = heroBanner.expired
        self.expiryTime = heroBanner.expiryTime
        self.startTime = heroBanner.startTime
        self.admob = heroBanner.admob
        self.adUnitId = heroBanner.adUnitId
    }
    
    internal init(withBannerImage heroBanner: HeroBanner.BannerImage) {
        self.redirectionURL = heroBanner.redirectionalURL
        self.redirectionPartnerLogo = heroBanner.redirectionPartnerLogo

        if let bannerImage = heroBanner.bannerImage {
            self.imagePath = bannerImage
        }
        self.expired = heroBanner.expired
        self.expiryTime = heroBanner.expiryTime
        self.startTime = heroBanner.startTime
        self.admob = heroBanner.admob
        self.adUnitId = heroBanner.adUnitId
    }
    
    init(withImageGridData data: Carousels) {
        self.imagePath = data.imagePath
        self.title = data.title
        self.subTitle = data.subTitle
        self.redirectionURL = data.redirectionURL
        self.redirectionPartnerLogo = data.redirectionPartnerLogo
    }
    
    init(withPartnerDetails data: OtherPartner.PartnerDetails.PageCarouselElements, logoImagePath: String) {
        self.imagePath = data.imagePath
        self.title = data.title
        self.redirectionURL = data.redirectionURL
        self.redirectionPartnerLogo = logoImagePath
    }
    init(withAuthCarouselElmts data: ShowcaseCarousel) {
        self.imagePath = data.imagePath
        self.redirectionURL = data.redirectionURL
    }
}
