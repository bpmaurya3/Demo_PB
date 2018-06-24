//
//  EarnProductDetailsRequestModel.swift
//  PayBack
//
//  Created by Dinakaran M on 02/11/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

 struct EarnProductDetailsRequestModel: Codable {

    var type: String
    var data: Data
    init(type: String, data: Data) {
        self.type = type
        self.data = data
    }
    struct Data: Codable {
        var id: String
        init(id: String) {
            self.id = id
        }
    }
    
}
