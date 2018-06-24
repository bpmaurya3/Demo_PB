//
//  AddToCartRequestModel.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 12/13/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

struct AddToCartRequestModel: Encodable {
    let type: String
    let cartId: String
    let data: Data
    
    init(type: String, cartId: String, data: Data) {
        self.type = type
        self.cartId = cartId
        self.data = data
    }
    
    struct Data: Encodable {
        let productId: String
        let quantity: String
        let amexEmail: String
        let amexMobile: String
        
        init(productId: String, quantity: String, amexEmail: String, amexMobile: String ) {
            self.productId = productId
            self.quantity = quantity
            self.amexEmail = amexEmail
            self.amexMobile = amexMobile
        }
    }
}
