//
//  DeliveryAddressFetcher.swift
//  PayBack
//
//  Created by Mohsin Surani on 16/11/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

final internal class DeliveryAddressFetcher: Fetcher {
    typealias SuccessHandler = ((DeliveryAddress) -> Void)?
    typealias OnInsertSuccessHandler = (() -> Void)?
    fileprivate var successHandler: SuccessHandler = { _ in }
    fileprivate var onInsertSuccessHandler: OnInsertSuccessHandler = { }

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
    func getAddress() {
        let requestBody = RequestBody.getDeliveryAddress(userid: UserProfileUtilities.getUserID())
        self.networkFetch(request: RequestFactory.request(requestBody: requestBody))
    }
    
    func addAddress(userid: String, data: AddressSplitCellModel) {
        let requestBody = RequestBody.addDeliveryAddress(userid: userid, data: data)
        self.networkFetch(request: RequestFactory.request(requestBody: requestBody))
    }
    
    func updateAddress(userid: String, data: AddressSplitCellModel) {
        let requestBody = RequestBody.updateDeliveryAddress(userid: userid, data: data)
        self.networkFetch(request: RequestFactory.request(requestBody: requestBody))
    }
    
    func deleteAddress(addressId: String) {
        let requestBody = RequestBody.deleteDeliveryAddress(userid: UserProfileUtilities.getUserID(), id: addressId)
        self.networkFetch(request: RequestFactory.request(requestBody: requestBody))
    }
    
    override func parse(data: Data) {
        let jsonDecoder = JSONDecoder()
        do {
            let response = try jsonDecoder.decode(DeliveryAddress.self, from: data)
                self.successHandler!(response)
                self.onInsertSuccessHandler!()
        } catch let jsonError {
            print("Delivery Address: Json Parsing Error: \(jsonError)")
        }
    }
}
