//
//  MyOrderDetailsFetcher.swift
//  PayBack
//
//  Created by Dinakaran M on 17/11/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

final internal class MyOrderDetailsFetcher: Fetcher {
    typealias SuccessHandler = ((MyOrderDetails) -> Void)?
    fileprivate var successHandler: SuccessHandler = { _ in }
    
    @discardableResult
    func onSuccess(success: SuccessHandler) -> Self {
        self.successHandler = success
        return self
    }
    
    func getMyOrderDetails(orderBatchId: String, orderId: String) {
        let requestBody = RequestBody.getMyOrderDetails(orderBatchId: orderBatchId, orderId: orderId)
        self.networkFetch(request: RequestFactory.request(requestBody: requestBody))
    }
    override func parse(data: Data) {
        let jsonDecoder = JSONDecoder()
        do {
            let response = try jsonDecoder.decode(MyOrderDetails.self, from: data)
            self.successHandler!(response)
        } catch let jsonError {
            print("My Order Details: Json Parsing Error: \(jsonError)")
        }
    }
}
