//
//  MyOrder.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 10/26/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

struct MyOrder: Codable {
    let message: String?
    let statusCode: String?
    let extintGetOrderBatchList: [ExtintGetOrderBatchList]?
    
    struct ExtintGetOrderBatchList: Codable {
        let typesOrderBatchId: String?
        let typesOrderList: [TypesOrderList]?
        
        struct TypesOrderList: Codable {
            let typesCashAmount: String?
            let typesFullName: String?
            let typesItemName: String?
            let typesLoyCardNumber: String?
            let typesMemberAccountNumber: String?
            let typesOrderDate: String?
            let typesOrderId: String?
            let typesOrderStatus: String?
            let typesPartnerOrderId: String?
            let typesPoints: String?
        }
    }
}
