//
//  RedeemProduct.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 10/19/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

struct RedeemProduct: Decodable {
    
    let count: String?
    let filters: [Filter]?
    
    let result: [Result]?
    
    struct Result: Decodable {
        let productId: String?
        let name: String?
        let price: Price?
        let images: Images?
        
        struct Price: Decodable {
            let actualPoints: NSInteger?
            let basePoints: NSInteger?
        }
        
        struct Images: Decodable {
            let small: [String]?
            let medium: [String]?
            let large: [String]?
            let thumbnails: [String]?
        }
    }
    struct Filter: Decodable {
        let type: String?
        let displayName: String?
        let values: [Values]?
    }
    struct Values: Decodable {
        let name: String?
        let id: String?
    }
}
