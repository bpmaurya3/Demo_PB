//
//  MyOrderTVCellModel.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 10/26/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

struct MyOrderTVCellModel {
    
    var orderDate: String?
    var orderId: String?
    var image: UIImage?
    var title: String?
    var price: String?
    var orderStatus: String?
    var orderStatusDate: String?
    var orderBatchId: String?
    
    init(orderDate: String, orderId: String, image: UIImage, title: String, price: String, orderStatus: String, orderStatusDate: String = "") {
        self.orderDate = orderDate
        self.orderId = orderId
        self.image = image
        self.title = title
        self.price = price
        self.orderStatus = orderStatus
        self.orderStatusDate = orderStatusDate
    }
    
    init(withMyOrder order: MyOrder.ExtintGetOrderBatchList) {
        if let orderData = order.typesOrderList?[0] {
            self.orderId = orderData.typesOrderId
            self.orderStatus = orderData.typesOrderStatus
            self.title = orderData.typesItemName
            self.price = orderData.typesPoints
            if let orderDate = orderData.typesOrderDate {
                //let date = Utilities.getDayMonthYear(date: orderDate)
                self.orderDate = orderDate
            }
        }
        self.orderBatchId = order.typesOrderBatchId
       
    }
}
