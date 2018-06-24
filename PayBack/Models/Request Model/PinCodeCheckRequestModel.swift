//
//  PinCodeCheckRequestModel.swift
//  PayBack
//
//  Created by Dinakaran M on 07/11/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

struct PinCodeCheckRequestModel: Codable {
    let type: String
    let vendorCode: String
    let data: Data
    init(type: String, data: Data) {
        self.type = type
        self.vendorCode = StringConstant.vendorCode
        self.data = data
    }
    struct Data: Codable {
        let pinCode: String
        //let productId: String
        init(productID: String, pincode: String) {
            //self.productId = productID
            self.pinCode = pincode
        }
    }
    
}
