//
//  CompareModel.swift
//  PaybackPopup
//
//  Created by Mohsin Surani on 29/08/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation
import UIKit

final internal class CompareCellModel {
    var canceledPrice: String?
    var actualPrice: String?
    var discountedRate: String?
    var points: Int = 0
    var offerComImage: UIImage?
    var shopNowLink: String?
    var partnerLogo: String?

    init?(canceledPrice: String, realPrice: String?, discountedRate: String?, offerImageLink: String?, points: Int, shopNowLink: String?) {

        self.canceledPrice = canceledPrice
        self.actualPrice = realPrice
        self.discountedRate = discountedRate
        self.points = points
        self.partnerLogo = offerImageLink
        self.shopNowLink = shopNowLink
    }
    
    init(withProductDetails result: EarnProductDetails.Results) {
        if let origPrize = result.origPrice {
            self.canceledPrice = String(origPrize)
        }
        if let fPrize = result.finalPrice {
            self.actualPrice = String(fPrize)
        }
        if let disCountPrize = result.discountVal {
            self.discountedRate = String(disCountPrize)
        }
        if let point = result.pbStoreData?.totalPoints {
           self.points = point
        }
        self.shopNowLink = result.url
        self.partnerLogo = result.storeLogo
    }
}
