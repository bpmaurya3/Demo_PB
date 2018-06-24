//
//  MyOrderStatusFetcher.swift
//  PayBack
//
//  Created by Dinakaran M on 21/11/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

class MyOrderStatusFetcher: Fetcher {
    typealias SuccessHandler = ((TrackOrderStatus) -> Void)?
    fileprivate var successHandler: SuccessHandler = { _ in }
    
    @discardableResult
    func onSuccess(success: SuccessHandler) -> Self {
        self.successHandler = success
        return self
    }
    func getMyOrderStatus(orderBatchId: String, orderId: String) {
        let requestBody = RequestBody.getMyOrderStatus(orderBatchId: orderBatchId, orderId: orderId)
        self.networkFetch(request: RequestFactory.request(requestBody: requestBody))
    }
    override func parse(data: Data) {
        let jsonDecoder = JSONDecoder()
        do {
            let response = try jsonDecoder.decode(TrackOrderStatus.self, from: data)
            self.successHandler!(response)
        } catch let jsonError {
            print("My Order Status: Json Parsing Error: \(jsonError)")
        }
    }
}
