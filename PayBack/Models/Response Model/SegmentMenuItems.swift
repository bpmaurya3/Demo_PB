//
//  SegmentMenuItems.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 10/30/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

struct OfferMenuItems: Codable {
    let errorMessage: String?
    let errorCode: String?
    
    let categories: [Category]?
    let departments: [String]?
    
    struct Category: Codable {
        let tagID: String?
        let tagTitle: String?
    }
}
