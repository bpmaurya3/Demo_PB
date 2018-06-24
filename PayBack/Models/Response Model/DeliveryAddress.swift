//
//  DeliveryAddress.swift
//  PayBack
//
//  Created by Mohsin Surani on 16/11/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

struct DeliveryAddress: Codable {
    
    let userid: String?
    let address: [Address]?
    let statusCode: String?
    let message: String?

    struct Address: Codable {
        let name: String?
        let address1: String?
        let address2: String?
        let city: String?
        let state: String?
        let pin: String?
        let mobile: String?
        let emailid: String?
        let defaultaddress: String?
        let id: String?
    }
}
