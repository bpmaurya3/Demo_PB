//
//  CouponsRequestModel.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 5/25/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import Foundation
struct CouponsRequestModel: Encodable {
    let type: String
    let data: Data
    init(type: String = "AllCoupons", data: Data) {
        self.type = type
        self.data = data
    }
    struct Data: Encodable {
        let page: String
        let per_page: String
        let store: String
        let filters: [String: String]
        
        init(page: String, per_page: String, store: String = "", filters: [String: String]) {
            self.page = page
            self.per_page = per_page
            self.store = store
            self.filters = filters
        }
    }
}
