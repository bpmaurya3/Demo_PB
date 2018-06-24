//
//  BurnProductDetailsRequestModel.swift
//  PayBack
//
//  Created by Dinakaran M on 31/10/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

struct BurnProductDetailsRequestModel: Codable {
    var type: String
    var searchType: String
    let vendorCode: String
    var data: Data
    init(type: String, searchType: String, data: Data) {
        self.type = type
        self.searchType = searchType
        self.vendorCode = StringConstant.vendorCode
        self.data = data
    }
    struct Data: Codable {
        var skip: String
        var limit: String
        var productId: String
        
        init(skip: String, limit: String, productId: String) {
            self.skip = skip
            self.limit = limit
            self.productId = productId
        }
    }
}
