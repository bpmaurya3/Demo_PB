//
//  MyOrderDetailsNWController.swift
//  PayBack
//
//  Created by Dinakaran M on 17/11/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

final internal class MyOrderDetailsNWController {
    var getMyOrderDetails = MyOrderDetailsFetcher()
    var getMyOrderStatus = MyOrderStatusFetcher()
    var detailInfoArray: [OrderInfoDetailCellModel] = []
   
    typealias UpdateTrackItemInfoHandler = ((TrackItemInfoCellModel) -> Void)?
    typealias UpdateTrackItemHandler = ((TrackItemCellModel) -> Void)?
    typealias UpdateItemDetailHandler = (([OrderInfoDetailCellModel]) -> Void)?
    typealias UpdateOrderStatusHandler = ((TrackDeliveryCellModel) -> Void)?
    
    fileprivate var updatetrackItemInfoHandler: UpdateTrackItemInfoHandler = { _ in }
    fileprivate var updatetrackItemHandler: UpdateTrackItemHandler = { _ in }
    fileprivate var updateItemDetailsHandler: UpdateItemDetailHandler = { _ in }
    fileprivate var updateOrderStatusHandler: UpdateOrderStatusHandler = { _ in }

    typealias SuccessHandler = ((String) -> Void)?
    typealias ErrorHandler = ((String) -> Void)?
    
    fileprivate var successHandler: SuccessHandler = { _ in }
    fileprivate var errorHandler: ErrorHandler = { _ in }
    fileprivate var tokenExpiredHandler: (() -> Void) = { }

    @discardableResult
    func onTrackItemInfo(trackItem: UpdateTrackItemInfoHandler) -> Self {
        self.updatetrackItemInfoHandler = trackItem
        return self
    }
    @discardableResult
    func onTrackItem(trackItem: UpdateTrackItemHandler) -> Self {
        self.updatetrackItemHandler = trackItem
        return self
    }
    @discardableResult
    func onItemDetails(trackDetailItem: UpdateItemDetailHandler) -> Self {
        self.updateItemDetailsHandler = trackDetailItem
        return self
    }
    @discardableResult
    func onOrderStatus(trackOrderStatus: UpdateOrderStatusHandler) -> Self {
        self.updateOrderStatusHandler = trackOrderStatus
        return self
    }
    
    @discardableResult
    func onSuccess(success: SuccessHandler) -> Self {
        self.successHandler = success
        return self
    }
    @discardableResult
    func onError(error: ErrorHandler) -> Self {
        self.errorHandler = error
        return self
    }
    func onTokenExpired(tokenExpired: @escaping (() -> Void)) -> Self {
        self.tokenExpiredHandler = tokenExpired
        
        return self
    }
    
    func getMyOrderStatus(orderBatchId: String, orderId: String) {
        getMyOrderStatus
            .onTokenExpired(tokenExpired: tokenExpiredHandler)
            .onError { [weak self] (error) in
                self?.errorHandler!(error)
            }
            .onSuccess { [weak self] (myOrderDetailsModel) in
                self?.successHandler!("Track Order Status Success")
                self?.updateTrackStatus(orderDetail: myOrderDetailsModel)
            }.getMyOrderStatus(orderBatchId: orderBatchId, orderId: orderId)
    }
    
    func updateTrackStatus(orderDetail: TrackOrderStatus) {
        if let orderStatus = orderDetail.extintOrderStatus {
           let orderStatusModel = TrackDeliveryCellModel(statusMsg: orderStatus)
            self.updateOrderStatusHandler!(orderStatusModel!)
        }
    }
    func getMyOrderDetails(orderBatchId: String, orderId: String) {
        getMyOrderDetails
            .onTokenExpired(tokenExpired: tokenExpiredHandler)
            .onError { [weak self] (error) in
                self?.errorHandler!(error)
            }
            .onSuccess { [weak self] (myOrderDetailsModel) in
                self?.successHandler!("Get Order Detail Success")
                self?.updateTrackItemInfoCellModel(orderDetail: myOrderDetailsModel)
                self?.updateTrackItem(orderDetail: myOrderDetailsModel)
                self?.updateDetailInfo(orderDetails: myOrderDetailsModel)
            }.getMyOrderDetails(orderBatchId: orderBatchId, orderId: orderId)
    }
    func updateTrackItemInfoCellModel(orderDetail: MyOrderDetails) {
        let trackModel = TrackItemInfoCellModel(itemDate: orderDetail.extintOrderDate!, itemCode: orderDetail.extintOrderId!, itemQty: orderDetail.extintQuantity!)
        self.updatetrackItemInfoHandler!(trackModel!)
    }
    func updateTrackItem(orderDetail: MyOrderDetails) {
        let trackItem = TrackItemCellModel(title: orderDetail.extintItemName!, image: nil, price: orderDetail.extintUnitPrice!)
        self.updatetrackItemHandler!(trackItem!)
    }
    func updateDetailInfo(orderDetails: MyOrderDetails) {
        if let earnPoint = orderDetails.extintPoints {
            let data = OrderInfoDetailCellModel(titleName: "Points earned", value: earnPoint, isShippingAddress: false)
            detailInfoArray.append(data!)
        }
        if let seller = orderDetails.extintPartnerName {
            let data = OrderInfoDetailCellModel(titleName: "Seller", value: seller, isShippingAddress: false)
            detailInfoArray.append(data!)
        }
        if let awdID = orderDetails.extintItemId {
            let data = OrderInfoDetailCellModel(titleName: "AWB ID", value: awdID, isShippingAddress: false)
            detailInfoArray.append(data!)
        }
        if let delivery = orderDetails.extintOrderDate {
            let data = OrderInfoDetailCellModel(titleName: "Delivery", value: delivery, isShippingAddress: false)
            detailInfoArray.append(data!)
        }
        if let shippingAddress = orderDetails.extintShipmentInfo {
          self.shippingAddress(shippingAddress: shippingAddress)
        }
        self.updateItemDetailsHandler!(detailInfoArray)
    }
    func shippingAddress(shippingAddress: MyOrderDetails.ExtintShipmentInfo) {
        var address: String = ""
        var deliveryName: String = ""
        if let name = shippingAddress.typesShipmentSenderName {
            deliveryName = name
        }
        if let address1 = shippingAddress.typesAddressLine1 {
            address.append(address1 + ",")
        }
        if let address2 = shippingAddress.typesAddressLine2 {
            address.append(address2 + ", \n")
        }
        if let city = shippingAddress.typesCity {
            address.append(city)
        }
        if let pincode = shippingAddress.typesZipCode {
            address.append(" - " + pincode)
        }
        if let state = shippingAddress.typesState {
            address.append("\n" + state)
        }
        if let mobile = shippingAddress.typesMobile {
            let mobleNum = Utilities.getHiddenMobileNumber(mobileNum: mobile)
            address.append("\nMobile " + mobleNum)
        }
        let data = OrderInfoDetailCellModel(titleName: deliveryName, value: address, isShippingAddress: true)
        detailInfoArray.append(data!)
    }
}
