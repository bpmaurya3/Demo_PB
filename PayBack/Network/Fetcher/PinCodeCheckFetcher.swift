//
//  PinCodeCheckFetcher.swift
//  PayBack
//
//  Created by Dinakaran M on 07/11/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

final internal class PinCodeCheckFetcher: Fetcher {
    typealias SuccessHandler = ((String) -> Void)?
    fileprivate var successHandler: SuccessHandler = { _ in }
    
    @discardableResult
    func onSuccess(success: SuccessHandler) -> Self {
        self.successHandler = success
        return self
    }
    
    func checkPinCode(pinCode: String, productId: String) {
        let requestBody = RequestBody.checkPinCode(pinCode: pinCode, productId: productId)
        self.networkFetch(request: RequestFactory.request(requestBody: requestBody))
    }
    override func parse(data: Data) {
        let jsonDecoder = JSONDecoder()
        do {
            let response = try jsonDecoder.decode(PinCodeCheck.self, from: data)
            if let msg = response.message {
                self.successHandler!(msg)
            }
        } catch let jsonError {
            print("PinCode Check: Json Parsing Error: \(jsonError)")
        }
    }
}
