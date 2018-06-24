//
//  ProductListRequestModel.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 10/13/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

internal class ProductListRequestModel {
    struct MobileSearch: Codable {
        let type: String
        let data: MobileSearchData
        
        init(type: String = "ShopOnlineProductSearch", data: MobileSearchData ) {
            self.type = type
            self.data = data
        }
        
        struct MobileSearchData: Codable {
            let term: String
            let page: String
            let per_page: String
            let sortby: String
            let filters: [String: String]
            
            init(searchText: String, page: String, per_page: String, sortby: String, filters: [String: String]) {
                self.term = searchText
                self.page = page
                self.per_page = per_page
                self.sortby = sortby
                self.filters = filters
            }
        }
    }
    
    struct BurnProductList: Codable {
        let type: String
        let searchType: String
        let data: BurnProductListData
        let vendorCode: String
        
        init(type: String = "rewardsSearchWithAll", searchType: String = "burn", data: BurnProductListData ) {
            self.type = type
            self.searchType = searchType
            self.data = data
            self.vendorCode = StringConstant.vendorCode
        }
    }

}

struct BurnProductListData: Codable {
    var skip: String
    var limit: String
    var searchText: String?
    var categoryPath: String?
    var minPoints: String?
    var maxPoints: String?
    var brand: String?
    var sort: String?
    
    init(skip: String, limit: String, searchText: String, categoryPath: String, minPoints: String, maxPoints: String, brand: String, sort: String) {
        self.skip = skip
        self.limit = limit
        self.searchText = searchText
        self.categoryPath = categoryPath
        self.minPoints = minPoints
        self.maxPoints = maxPoints
        self.brand = brand
        self.sort = sort
    }
}
