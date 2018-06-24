//
//  PointCalculator.swift
//  PayBack
//
//  Created by Mohsin Surani on 20/12/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

struct PointCalculator: Decodable {
    
    let pointsCalculatorInfo: PointsCalculatorInfo?
    
    struct PointsCalculatorInfo: Decodable {
        let redeemPointsValue: Float?
        let maxEarnPointsValue: Int?
        let categories: [Categories]?
        
        struct Categories: Decodable {
            let iconImage: String?
            let iconText: String?
            let minValue: Int?
            let maxValue: Int?
            let earnPointsForValue: Float?
            let initialValue: Int?
        }
    }
}
