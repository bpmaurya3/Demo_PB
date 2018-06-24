//
//  BurnProductDetailsFetcher.swift
//  PayBack
//
//  Created by Dinakaran M on 31/10/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

final internal class BurnProductDetailsFetcher: Fetcher {
    typealias SuccessHandler = ((BurnProductDetails) -> Void)?
    fileprivate var successHandler: SuccessHandler = { _ in }
    
    @discardableResult
    func onSuccess(success: SuccessHandler) -> Self {
        self.successHandler = success
        return self
    }
    func getProductDetails(productID: String) {
        let requestBody = RequestBody.getBurnProductDetails(productID: productID)
        self.networkFetch(request: RequestFactory.request(requestBody: requestBody))
    }
    override func parse(data: Data) {
        let jsonDecoder = JSONDecoder()
        do {
            let response = try jsonDecoder.decode(BurnProductDetails.self, from: data)
            self.successHandler!(response)
        } catch let jsonError {
            print("Burn Product Details: Json Parsing Error: \(jsonError)")
        }
    }
}
