//
//  OtherPartner.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 9/13/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

/* enable when json decoder will be stable : @available Swift 4.0*/
internal struct OtherPartner: Codable {
    let errorCode: String?
    let errorMessage: String?
    
    let partnerDetails: [PartnerDetails]?
    
    struct PartnerDetails: Codable {
        let tileBackgroundImage: String?
        let tileBackgroundColor: String?
        let logoImage: String?
        let description: String?
        let linkText: String?
        let linkUrl: String?
        // Used in Partner Detail Page
        let pageTitle: String?
        let pageDescription: String?
        let ctaButtonText: String?
        let ctaButtonLink: String?
        let videotutorialText: String?
        let videoTutorialLink: String?
        let pageCarouselElements: [PageCarouselElements]?
        let pageCarouselExp: Bool?
        let isOtherPartner: Bool?
        let isIntermdPgReq: Bool?
        
        struct PageCarouselElements: Codable {
            let imagePath: String?
            let title: String?
            let uniquePageID: String?
            let redirectionURL: String?
        }
    }
}
/*
struct OtherPartner {
    private let data: [String: Any]
    
    var description: String? {
        return  data["description"] as? String
    }
    var linkText: String? {
        return  data["linkText"] as? String
    }
    
    var linkUrl: String? {
        return  data["linkUrl"] as? String
    }
    var logoImage: String? {
        return data["logoImage"] as? String
    }
    
    init(fromData data: [String: Any]) {
        self.data = data
    }
}*/
