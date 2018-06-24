//
//  PaybackPlusExclusive.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 11/23/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

struct PaybackPlusExclusive: Decodable {
    let errorCode: String?
    let errorMessage: String?
    
    let iconDescGridView: [IconDescGridView]?
    
    struct IconDescGridView: Decodable {
        let imagePath: String?
        let description: String?
        let title: String?
    }
}
