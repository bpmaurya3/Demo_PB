//
//  EarnProductDetailsFetcher.swift
//  PayBack
//
//  Created by Dinakaran M on 03/11/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

final internal class EarnProductDetailsFetcher: Fetcher {
    typealias SuccessHandler = ((EarnProductDetails) -> Void)?
    fileprivate var successHandler: SuccessHandler = { _ in }
    
    @discardableResult
    func onSuccess(success: SuccessHandler) -> Self {
        self.successHandler = success
        return self
    }
    func getProductDetails(productID: String) {
        let requestBody = RequestBody.getEarnProductDetails(productID: productID)
        self.networkFetch(request: RequestFactory.request(requestBody: requestBody))
    }
    override func parse(data: Data) {
        let jsonDecoder = JSONDecoder()
        do {
            let response = try jsonDecoder.decode(EarnProductDetails.self, from: data)
            self.successHandler!(response)
        } catch let jsonError {
            print("Earn Product Details: Json Parsing Error: \(jsonError)")
             self.errorHandler("Internal server error")
        }
    }
}
