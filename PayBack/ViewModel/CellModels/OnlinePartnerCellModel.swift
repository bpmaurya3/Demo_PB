//
//  OnlinePartnerCellModel.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 9/13/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

class OnlinePartnerCellModel: NSObject {
    
    var logoImage: String?
    var descriptionText: String?
    var linkText: String?
    var linkUrl: String?
    
    init(withOtherPartner otherPartner: OtherPartner.PartnerDetails) {
        self.logoImage = otherPartner.logoImage
        self.descriptionText = otherPartner.description
        self.linkText = otherPartner.linkText
        self.linkUrl = otherPartner.linkUrl
    }
    
    init(image: String, earnPoints: String) {
        self.logoImage = image
        self.descriptionText = earnPoints
    }
}
