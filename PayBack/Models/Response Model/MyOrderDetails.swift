//
//  MyOrderDetails.swift
//  PayBack
//
//  Created by Dinakaran M on 17/11/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation
// MyOrderDetails for - Get Order Details and Get Order Status
struct MyOrderDetails: Codable {
    let extintShipmentInfo: ExtintShipmentInfo?
    let message: String?
    let statusCode: String?
    struct ExtintShipmentInfo: Codable {
        let typesShipmentDeliverTo: String?
        let typesMobile: String?
        let typesAddressLine1: String?
        let typesZipCode: String?
        let typesAddressLine2: String?
        let typesState: String?
        let typesEmail: String?
        let typesShipmentSenderName: String?
        let typesPhone: String?
        let typesCity: String?
    }
    let extintOrderDate: String?
    let extintItemName: String?
    let extintItemId: String?
    let extintPartnerOrderBatchId: String?
    let extintMinimumPointCost: String?
    let extintPartnerOrderId: String?
    let extintUnitPrice: String?
    let extintQuantity: String?
    let extintUserId: String?
    let extintOrderBatchId: String?
    let extintOrderId: String?
    let extintRedeemChannel: String?
    let extintCategoryName: String?
    let extintMemberAccountNumber: String?
    let extintReferenceAmount: String?
    let extintTxnMerchantId: String?
    let extintGiftWrappingRequired: String?
    let extintItemType: String?
    let extintLoyCardNumber: String?
    let extintTerminalId: String?
    let extintOrderType: String?
    let extintPartnerName: String?
    let extintCashAmount: String?
    let extintDiscountValue: String?
    let extintPoints: String?
    let extintUserName: String?
    let extintPaymentChannel: String?
    let extintFullName: String?
    let extintTotalCostPoints: String?
    let extintOrderStatusName: String?
    let extintOrderStatus: String?
}
  // get OrderStatus
struct TrackOrderStatus: Codable {
    let extintOrderStatus: String?
    let extintPartnerOrderBatchId: String?
    let extintOrderBatchId: String?
    let extintPartnerOrderId: String?
    let extintOrderId: String?
    let message: String?
    let statusCode: String?
}
