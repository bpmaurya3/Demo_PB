//
//  TopTrendRequestModel.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 11/30/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

struct TopTrendRequestModel: Encodable {
    let type: String
    let data: Data
    
    init(type: String, data: Data) {
        self.type = type
        self.data = data
    }
    
    struct Data: Encodable {
        var id: String?
        var type: String?
        let page: String
        let per_page: String
        let sortby: String
        let filters: [String: String]
        
        init(type: String? = nil, id: String? = nil, page: String, per_page: String, sortby: String = "", filters: [String: String]) {
            if let id = id {
                self.id = id
            }
            if let type = type {
                self.type = type
            }
            self.page = page
            self.per_page = per_page
            self.sortby = sortby
            self.filters = filters
        }
    }
}
