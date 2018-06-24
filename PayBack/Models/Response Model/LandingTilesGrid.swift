//
//  LandingTilesGrid.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 9/27/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

struct LandingTilesGrid: Codable {
    let errorCode: String?
    let errorMessage: String?
    
    let carousels: [Carousels]?
    let imageGrid: [Carousels]?
    let expired: Bool?
    let expiryTime: String?
    let startTime: String?
}
struct Carousels: Codable {
    let imagePath: String?
    let iconImagePath: String?
    let title: String?
    let subTitle: String?
    let redirectionURL: String?
    let redirectionPartnerLogo: String?
    let uniquePageID: String?
    let allowBgLayout: Bool?
}
