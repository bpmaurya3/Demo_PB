//
//  GetOrderDetailsRequestModel.swift
//  PayBack
//
//  Created by Dinakaran M on 17/11/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

struct GetOrderDetailsRequestModel: Codable {
    var GetOrderDetailsRequest: GetOrderDetailsRequest
    struct GetOrderDetailsRequest: Codable {
        var MemberAuthentication: MemberAuthentication
        var LMSOrderDetails: LMSOrderDetails
        var RedeemChannel: String
        init(memberAuthentication: MemberAuthentication, lmsOrderDetails: LMSOrderDetails, redeemChannel: String) {
            self.MemberAuthentication = memberAuthentication
            self.LMSOrderDetails = lmsOrderDetails
            self.RedeemChannel = redeemChannel
        }
    }
}
struct CheckOrderStatusRequestModel: Codable {
    var CheckOrderStatusRequest: CheckOrderStatusRequest
    init(checkOrderStatusRequest: CheckOrderStatusRequest) {
        self.CheckOrderStatusRequest = checkOrderStatusRequest
    }
    struct CheckOrderStatusRequest: Codable {
        var MemberAuthentication: MemberAuthentication
        var LMSOrderDetails: LMSOrderDetails
        var RedeemChannel: String
        init(memberAuthentication: MemberAuthentication, lmsOrderDetails: LMSOrderDetails, redeemChannel: String) {
            self.MemberAuthentication = memberAuthentication
            self.LMSOrderDetails = lmsOrderDetails
            self.RedeemChannel = redeemChannel
        }
    }
}

struct MemberAuthentication: Codable {
    var AuthenticationNumber: String
    var AssociationType: String
    init(authenticationNumber: String, associationType: String = "TOKEN") {
        self.AuthenticationNumber = authenticationNumber
        self.AssociationType = associationType
    }
}
struct LMSOrderDetails: Codable {
    var OrderBatchId: String
    var OrderId: String
    init(orderBatchId: String, OrderId: String) {
        self.OrderBatchId = orderBatchId
        self.OrderId = OrderId
    }
}
