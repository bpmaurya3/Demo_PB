//
//  SpecificationModel.swift
//  PaybackPopup
//
//  Created by Mohsin Surani on 31/08/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation
import UIKit

class SpecificationCellModel: NSObject {
    var featureType: String?
    var featureDetail: String?
    
    init?(featureType: String, featureDetail: String) {
        super.init()
        
        self.featureType = featureType
        self.featureDetail = featureDetail
    }
    init(withRedeemSpecification spec: FeatureAttribute) {
        self.featureType = spec.name
        self.featureDetail = spec.value
    }
}
