//
//  TopTrend.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 11/30/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

struct TopTrend: Decodable {
    let totalCount: NSInteger?
    let results: [Trending]?
    let filters: [ProductFilter]?
    let sortBy: [SortByModel]?
    let priceRange: PriceRange?
    
    struct Trending: Decodable {
        let itemType: String?
        let id: String?
        let url: String?
        let sourceid: String?
        let title: String?
        let img: String?
        let category: String?
        let details: String?
        let store: String?
        let storeLogo: String?
        let promotionType: String?
        let origPrice: String?
        let finalPrice: String?
        let imagename: String?
        let scandidUrl: String?
        let appDeepLink: String?
        let featured: String?
        let discount: Int?
        let pbStoreData: PBStoreData?
        let numTotalStores: Int?
        let instock: String?
    }
    
}
struct PBStoreData: Decodable {
    let totalPoints: Int?
    let pointText: String?
}
class PriceRange: Decodable {
    var min: Int?
    var max: Int?
}
struct SortByModel: Decodable {
    let label: String?
    let keyword: String?
}
struct ProductFilter: Decodable {
    let type: String?
    let displayName: String?
    let values: [String]?
}
struct CategoryProduct: Decodable {
    let totalCount: Int?
    let products: [CategoryProducts]?
    let filters: [ProductFilter]?
    let sortBy: [SortByModel]?
    let priceRange: PriceRange?
    
    struct CategoryProducts: Decodable {
        let itemType: String?
        let id: String?
        let url: String?
        let sourceid: String?
        let title: String?
        let img: String?
        let category: String?
        let details: String?
        let store: String?
        let storeLogo: String?
        let promotionType: String?
        let origPrice: Int64?
        let finalPrice: Int64?
        let imagename: String?
        let scandidUrl: String?
        let appDeepLink: String?
        let featured: String?
        let discountVal: Int?
        let pbStoreData: PBStoreData?
        let numTotalStores: Int?
        let numInstockStores: Int?
    }
}
