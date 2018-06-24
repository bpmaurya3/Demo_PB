//
//  CouponsRecharge.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 10/30/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

struct CouponsRecharge: Codable {
    let errorMessage: String?
    let errorCode: String?
    
    let tileGridElements: [ResponseData]?
    let verticalTileGridElements: [ResponseData]?
    
    struct ResponseData: Codable {
        let gridImagePath: String?
        let gridImageTitle: String?
        let gridImageSubtitle: String?
        let redirectionURL: String?
        let uniquePageID: String?
        let promocode: String?
        let termsAndCondition: String?
        let buttonText1: String?
        var buttonText2: String?
        var ctaButtonLink1: String?
        var ctaButtonLink2: String?
        let filterTags: [String]?
    }
}
