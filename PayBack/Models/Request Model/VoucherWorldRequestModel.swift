//
//  VoucherWorldRequestModel.swift
//  PayBack
//
//  Created by Sudhansh Gupta on 17/05/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import Foundation

struct VoucherWorldRequestModel: Encodable {
    let type: String
    let text: String
    init(type: String = "keyEncryption", authToken: String) {
        self.type = type
        self.text = authToken
    }
}
