//
//  BurnProductDetails.swift
//  PayBack
//
//  Created by Dinakaran M on 31/10/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

struct BurnProductDetails: Codable {
    let count: String?
    let minPoints: String?
    let maxPoints: String?
    let brands: [String]?
    let result: [Result]?
    let message: String?
    let statusCode: String?

    struct Result: Codable {
        let productId: String?
        let name: String?
        let shortDescription: String?
        let description: String?
        let categoryPath: [String]?
        let brand: String?
        let price: Price?
        let images: Images?
        let variants: [String]?
        let skus: [String]?
        let isActive: Bool?
        let sequence: Int?
        let prioritySequence: Int?
        let deliveryCities: String?
        let stock: Int?
        let refundPolicy: String?
        let shareUrl: String?
        let specifications: [FeatureAttribute]?
        let review: [String]?
        struct Price: Codable {
            let mrp: Float?
            let clientPrice: Float?
            let discount: Float?
            let minimumPoints: Float?
            let minimumCash: Float?
            let basePoints: Float?
            let actualPoints: Float?
            let ratio: Float?
        }
        struct Images: Codable {
            let small: [String]?
            let medium: [String]?
            let large: [String]?
            let thumbnails: [String]?
        }
        
    }
}
