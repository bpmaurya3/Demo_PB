//
//  CartReviewNWController.swift
//  PayBack
//
//  Created by Mohsin Surani on 16/11/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

final internal class CartReviewNWController {
    var deliveryAddress = DeliveryAddressFetcher()
    
    typealias SuccessHandler = (([AddressSplitCellModel]) -> Void)?
    typealias OnInsertSuccessHandler = (() -> Void)?
    typealias ErrorHandler = ((String) -> Void)?
    
    fileprivate var successHandler: SuccessHandler = { _ in }
    fileprivate var onInsertSuccessHandler: OnInsertSuccessHandler = { }
    fileprivate var onDeleteSuccessHandler: OnInsertSuccessHandler = { }
    fileprivate var onUpdateSuccessHandler: OnInsertSuccessHandler = { }
    fileprivate var errorHandler: ErrorHandler = { _ in }
    
    let createOrderFetcher = CreateOrderFetcher()
    fileprivate var createOrderSuccessHandler: ((String) -> Void) = { _ in }
    fileprivate var createOrderErrorHandler: ((String) -> Void) = { _ in }
    
    fileprivate var tokenExpiredHandler: (() -> Void) = { }

    func getAddresss() {
        deliveryAddress
            .onError { [weak self] (error) in
                self?.errorHandler!(error)
            }
            .onSuccess { [weak self] (result) in
                self?.configureData(data: result)
            }
            .getAddress()
    }
    
    func deleteAddresss(addressId: String) {
        deliveryAddress
            .onError { [weak self] (error) in
                self?.errorHandler!(error)
            }
            .onInsertSuccess { [weak self] in
                if let handler = self?.onDeleteSuccessHandler {
                    handler()
                    self?.onDeleteSuccessHandler = nil
                }
            }
            .deleteAddress(addressId: addressId)
    }
    
    func addAddresss(userid: String, data: AddressSplitCellModel) {
        
        deliveryAddress
            .onError { [weak self] (error) in
                self?.errorHandler!(error)
            }
            .onInsertSuccess { [weak self] in
                if let handler = self?.onInsertSuccessHandler {
                    handler()
                    self?.onInsertSuccessHandler = nil
                }
            }
            .addAddress(userid: userid, data: data)
    }
    
    func updateAddresss(userid: String, data: AddressSplitCellModel) {
        deliveryAddress
            .onError { [weak self] (error) in
                self?.errorHandler!(error)
            }
            .onInsertSuccess { [weak self] in
                if let handler = self?.onUpdateSuccessHandler {
                    handler()
                    self?.onUpdateSuccessHandler = nil
                }
            }
            .updateAddress(userid: userid, data: data)
    }
    
    func createOrder(shipmentInfo: AddressSplitCellModel, productInfo: CreateOrderProductInfoModel) {
        createOrderFetcher
            .onTokenExpired { [weak self] in
                self?.tokenExpiredHandler()
            }
            .onSuccess { [weak self] (message)in
                self?.createOrderSuccessHandler(message)
            }
            .onError { [weak self] (error) in
                self?.createOrderErrorHandler(error)
            }
            .createOrder(shipmentInfo: shipmentInfo, productInfo: productInfo)
    }
}

extension CartReviewNWController {
    @discardableResult
    func onSuccess(success: SuccessHandler) -> Self {
        self.successHandler = success
        return self
    }
    
    @discardableResult
    func onInsertSuccess(success: OnInsertSuccessHandler) -> Self {
        self.onInsertSuccessHandler = success
        return self
    }
    @discardableResult
    func onDeleteSuccess(success: OnInsertSuccessHandler) -> Self {
        self.onDeleteSuccessHandler = success
        return self
    }
    @discardableResult
    func onUpdateSuccess(success: OnInsertSuccessHandler) -> Self {
        self.onUpdateSuccessHandler = success
        return self
    }
    
    @discardableResult
    func onError(error: ErrorHandler) -> Self {
        self.errorHandler = error
        return self
    }
    
    @discardableResult
    func onCreateOrderSuccess(success: @escaping ((String) -> Void)) -> Self {
        self.createOrderSuccessHandler = success
        return self
    }
    @discardableResult
    func onCreateOrderError(error: @escaping ((String) -> Void)) -> Self {
        self.createOrderErrorHandler = error
        return self
    }
    @discardableResult
    func onTokenExpired(tokenExpired: @escaping (() -> Void)) -> Self {
        self.tokenExpiredHandler = tokenExpired
        
        return self
    }
}

extension CartReviewNWController {
    fileprivate func configureData(data: DeliveryAddress) {
        guard let addressData = data.address else {
            return
        }
        var cellModelArray = [AddressSplitCellModel]()
        for data in addressData {
            cellModelArray.append(AddressSplitCellModel(withAddressDetails: data))
        }
        self.successHandler!(cellModelArray)
    }
}
