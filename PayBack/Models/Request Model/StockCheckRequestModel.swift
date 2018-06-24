//
//  StockCheckRequestModel.swift
//  PayBack
//
//  Created by Dinakaran M on 14/11/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

struct StockCheckRequestModel: Codable {
    var type: String
    var productId: String
    init(type: String, productID: String) {
        self.type = type
        self.productId = productID
    }
}
