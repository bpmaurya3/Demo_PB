//
//  StockCheckFetcher.swift
//  PayBack
//
//  Created by Dinakaran M on 14/11/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

final internal class StockCheckFetcher: Fetcher {
    typealias SuccessHandler = ((String) -> Void)?
    fileprivate var successHandler: SuccessHandler = { _ in }
    
    @discardableResult
    func onSuccess(success: SuccessHandler) -> Self {
        self.successHandler = success
        return self
    }
    func stockCheck(productId: String) {
        let requestBody = RequestBody.stockCheck(productId: productId)
        self.networkFetch(request: RequestFactory.request(requestBody: requestBody))
    }
    
    override func parse(data: Data) {
        let jsonDecoder = JSONDecoder()
        do {
            let response = try jsonDecoder.decode(StockCheck.self, from: data)
            if let stock = response.stock {
                self.successHandler!(stock)
            }
        } catch let jsonError {
            print("Stock Count Check: Json Parsing Error: \(jsonError)")
        }
    }
}
