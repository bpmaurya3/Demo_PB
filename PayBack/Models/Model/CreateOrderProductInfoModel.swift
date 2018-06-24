//
//  CreateOrderProductInfoModel.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 5/10/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import Foundation

struct CreateOrderProductInfoModel {
    let OrderType: String
    let ItemId: String
    let SkuCode: String
    let ItemName: String
    let Quantity: Int
    let points: Int?
    let UnitPrice: Int?
    let OrderStatus: String
    let ItemType: String
    let imagePath: String
    
    init(OrderType: String = "0", ItemId: String, SkuCode: String, ItemName: String, Quantity: Int, points: Int?, UnitPrice: Int?, OrderStatus: String = "APPROVED", ItemType: String = "PRD", imagePath: String) {
        self.OrderType = OrderType
        self.ItemId = ItemId
        self.SkuCode = SkuCode
        self.ItemName = ItemName
        self.Quantity = Quantity
        self.points = points
        self.UnitPrice = UnitPrice
        self.OrderStatus = OrderStatus
        self.ItemType = ItemType
        self.imagePath = imagePath
    }
}
