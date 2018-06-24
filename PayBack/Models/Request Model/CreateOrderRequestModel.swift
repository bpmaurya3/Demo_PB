//
//  CreateOrderRequestModel.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 11/27/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

struct CreateOrderRequestModel: Encodable {
    let vendorCode: String
    let userId: String
    let sessionId: String
    let CreateOrderRequest: CreateOrderRequest
    
    init(orderRequest: CreateOrderRequest, userId: String, sessionId: String) {
        self.CreateOrderRequest = orderRequest
        self.vendorCode = StringConstant.vendorCode
        self.userId = userId
        self.sessionId = sessionId
    }
    
    struct CreateOrderRequest: Encodable {
        let MemberAuthentication: MemberAuthentication
        let PartnerOrderBatchId: String
        let TxnMerchantId: String
        let TerminalId: String
        let OrderItem: [OrderItem]
        let TotalCashAmount: String
        let TotalPoints: String
        let TotalValue: String
        let ShipmentInfo: ShipmentInfo
        let RedeemChannel: String
        let GiftMessage: String
        let GiftWrappingRequired: String
        let AdditionalField1: String
        let AdditionalField2: String
        let SourceIPAddress: String
        let PaymentChannel: String
        
        init(MemberAuthentication: MemberAuthentication, PartnerOrderBatchId: String, TxnMerchantId: String = "90000003", TerminalId: String = "64200004", OrderItem: [OrderItem], TotalCashAmount: String, TotalPoints: String, TotalValue: String, ShipmentInfo: ShipmentInfo, RedeemChannel: String = "WEB", GiftMessage: String = "", GiftWrappingRequired: String = "NO", AdditionalField1: String = "", AdditionalField2: String = "", SourceIPAddress: String, PaymentChannel: String = "points") {
            self.MemberAuthentication = MemberAuthentication
            self.PartnerOrderBatchId = PartnerOrderBatchId
            self.TxnMerchantId = TxnMerchantId
            self.TerminalId = TerminalId
            self.OrderItem = OrderItem
            self.TotalCashAmount = TotalCashAmount
            self.TotalPoints = TotalPoints
            self.TotalValue = TotalValue
            self.ShipmentInfo = ShipmentInfo
            self.RedeemChannel = RedeemChannel
            self.GiftMessage = GiftMessage
            self.GiftWrappingRequired = GiftWrappingRequired
            self.AdditionalField1 = AdditionalField1
            self.AdditionalField2 = AdditionalField2
            self.SourceIPAddress = SourceIPAddress
            self.PaymentChannel = PaymentChannel
        }
    }
}

struct OrderItem: Encodable {
    let PartnerOrderId: String
    let OrderType: String
    let ItemId: String
    let ItemName: String
    let Quantity: String
    let UnitPrice: String
    let Points: String
    let CashAmount: String
    let MinimumPointCost: String
    let OrderStatus: String
    let CategoryName: String
    let DiscountType: String
    let DiscountValue: String
    let ItemType: String
    let ReferenceNumber: String
    let ReferenceDate: String
    let ReferenceAmount: String
    let ReferenceName: String
    let IsExpressDelivery: String
    let GiftMessage: String
    let GiftWrappingRequired: String
    let OtherDetails: String
    let SkuCode: String
    
    init(PartnerOrderId: String, OrderType: String = "0", ItemId: String, ItemName: String, Quantity: String, UnitPrice: String, Points: String, CashAmount: String = "0", MinimumPointCost: String = "100", OrderStatus: String, CategoryName: String = "featured", DiscountType: String = "", DiscountValue: String = "0", ItemType: String, ReferenceNumber: String = "", ReferenceDate: String = "", ReferenceAmount: String = "", ReferenceName: String = "", IsExpressDelivery: String = "NO", GiftMessage: String = "", GiftWrappingRequired: String = "YES", OtherDetails: String = "", SkuCode: String) {
        
        self.PartnerOrderId = PartnerOrderId
        self.OrderType = OrderType
        self.ItemId = ItemId
        self.ItemName = ItemName
        self.Quantity = Quantity
        self.UnitPrice = UnitPrice
        self.Points = Points
        self.CashAmount = CashAmount
        self.MinimumPointCost = MinimumPointCost
        self.OrderStatus = OrderStatus
        self.CategoryName = CategoryName
        self.DiscountType = DiscountType
        self.DiscountValue = DiscountValue
        self.ItemType = ItemType
        self.ReferenceNumber = ReferenceNumber
        self.ReferenceDate = ReferenceDate
        self.ReferenceAmount = ReferenceAmount
        self.ReferenceName = ReferenceName
        self.IsExpressDelivery = IsExpressDelivery
        self.GiftMessage = GiftMessage
        self.GiftWrappingRequired = GiftWrappingRequired
        self.OtherDetails = OtherDetails
        self.SkuCode = SkuCode
    }
}

struct ShipmentInfo: Encodable {
    let ShipmentSenderName: String
    let ShipmentDeliverTo: String
    let Email: String
    let Phone: String
    let Mobile: String
    let AddressLine1: String
    let AddressLine2: String
    let AddressLine3: String
    let AddressLine4: String
    let City: String
    let State: String
    let Region: String
    let Landmark: String
    let Country: String
    let ZipCode: String
    
    init(ShipmentSenderName: String, ShipmentDeliverTo: String = "", Email: String, Phone: String = "", Mobile: String, AddressLine1: String, AddressLine2: String, AddressLine3: String = "", AddressLine4: String = "", City: String, State: String, Region: String = "", Landmark: String = "", Country: String = "", ZipCode: String) {
        self.ShipmentSenderName = ShipmentSenderName
        self.ShipmentDeliverTo = ShipmentSenderName
        self.Email = Email
        self.Phone = Mobile
        self.Mobile = Mobile
        self.AddressLine1 = AddressLine1
        self.AddressLine2 = AddressLine2
        self.AddressLine3 = AddressLine3
        self.AddressLine4 = AddressLine4
        self.City = City
        self.State = State
        self.Region = Region
        self.Landmark = Landmark
        self.Country = Country
        self.ZipCode = ZipCode
    }
}
