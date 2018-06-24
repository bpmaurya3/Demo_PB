//
//  ShopOnlineProductParamsModel.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 4/3/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import Foundation

struct ShopOnlineProductParamsModel {
    let id: String
    let page: String
    let per_page: String
    let filter: [String: String]
    let sortBy: String
    
    init(id: String = "", page: String = "1", per_page: String = "10", filter: [String: String] = [:], sortBy: String = "") {
        self.id = id
        self.page = page
        self.per_page = per_page
        self.filter = filter
        self.sortBy = sortBy
    }
}
