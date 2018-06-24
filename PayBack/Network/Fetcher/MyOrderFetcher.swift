//
//  MyOrderFetcher.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 10/26/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

final internal class MyOrderFetcher: Fetcher {
    fileprivate var successHandler: ((MyOrder) -> Void)?

    func onSuccess(success: @escaping (MyOrder) -> Void) -> Self {
        self.successHandler = success
        return self
    }
    
    func fetchMyOrder() {
        let authToken = UserProfileUtilities.getAuthenticationToken()
        let requestBody = RequestBody.getMyOrder(token: authToken)
        self.networkFetch(request: RequestFactory.request(requestBody: requestBody))
    }
    
    override func parse(data: Data) {
        let jsonDecoder = JSONDecoder()
        do {
            let resultArray = try jsonDecoder.decode(MyOrder.self, from: data)
            self.successHandler!(resultArray)
        } catch let jsonError {
            print("MyOrderFetcher: Json Parsing Error: \(jsonError)")
            errorHandler(jsonError.localizedDescription)
        }
    }
    
}
