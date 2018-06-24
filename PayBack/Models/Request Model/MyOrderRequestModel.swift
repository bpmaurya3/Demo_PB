//
//  MyOrderRequestModel.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 10/26/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

struct MyOrderRequestModel: Codable {
    let GetOrderListRequest: GetOrderListRequest
    
    init(getOrderListRequest: GetOrderListRequest) {
        self.GetOrderListRequest = getOrderListRequest
    }
    
    struct GetOrderListRequest: Codable {
        let MemberAuthentication: MemberAuthentication
        
        init(memberAuthentication: MemberAuthentication) {
            self.MemberAuthentication = memberAuthentication
        }
    }
}
