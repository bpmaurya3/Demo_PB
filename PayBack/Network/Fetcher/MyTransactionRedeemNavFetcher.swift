//
//  MyTransactionRedeemNavFetcher.swift
//  PayBack
//
//  Created by valtechadmin on 5/11/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import Foundation

final internal class MyTransactionRedeemNavFetcher: Fetcher {
    typealias SuccessHandler = ((TransactionsRedeemNavDetails) -> Void)?
    fileprivate var successHandler: SuccessHandler = { _ in }
    
    @discardableResult
    func onSuccess(success: SuccessHandler) -> Self {
        self.successHandler = success
        return self
    }
    
    func getTransactionRedeemNavDetails() {
        self.networkFetch(request: RequestFactory.transactionRedeemNavDetails())
    }
    override func parse(data: Data) {
        let jsonDecoder = JSONDecoder()
        do {
            let response = try jsonDecoder.decode(TransactionsRedeemNavDetails.self, from: data)
            self.successHandler!(response)
        } catch let jsonError {
            self.errorHandler("Internal Error")
            print("My Transaction: Json Parsing Error: \(jsonError)")
        }
    }
}
