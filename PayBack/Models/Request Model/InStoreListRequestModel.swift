//
//  InStoreListRequestModel.swift
//  PayBack
//
//  Created by valtechadmin on 4/24/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import Foundation
struct InStoreListRequestModel: Encodable {
    let type: String
    let data: Data
    
    init(type: String, data: Data) {
        self.type = type
        self.data = data
    }
    
    struct Data: Encodable {
        let latitude: String
        let longitude: String
        let category: String
        let city: String
        let partner: String
        
        init(latitude: String, longitude: String, category: String = "", partner: String = "", city: String = "") {
            self.latitude = latitude
            self.longitude = longitude
            self.category = category
            self.city = city
            self.partner = partner
        }
    }
}

struct StoreLocaterFilterParameters {
    let category: String?
    let city: String?
    let  partner: String?
}
