//
//  CategoryRequestModel.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 10/12/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

struct CategoryRequestModel: Encodable {
    let type: String
    let searchType: String
    let vendorCode: String
    
    init(type: String, searchType: String) {
        self.type = type
        self.searchType = searchType
        self.vendorCode = StringConstant.vendorCode
    }
}
