//
//  MyTransactionFetcher.swift
//  PayBack
//
//  Created by Dinakaran M on 26/10/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

final internal class MyTransactionFetcher: Fetcher {
    typealias SuccessHandler = ((GetMyTransactions) -> Void)?
    fileprivate var successHandler: SuccessHandler = { _ in }
    
    @discardableResult
    func onSuccess(success: SuccessHandler) -> Self {
        self.successHandler = success
        return self
    }
    
    func getTransactionDetails(page: String, pageSize: String, filter: TransactionFilerTuple) {
        let requestBody = RequestBody.getMyTransaction(page: "\(page)", pageSize: "10", filter: filter)
        self.networkFetch(request: RequestFactory.request(requestBody: requestBody))
    }
    override func parse(data: Data) {
        let jsonDecoder = JSONDecoder()
        do {
            let response = try jsonDecoder.decode(GetMyTransactions.self, from: data)
            self.successHandler!(response)
        } catch let jsonError {
            self.errorHandler("Internal Error")
            print("My Transaction: Json Parsing Error: \(jsonError)")
        }
    }
}
