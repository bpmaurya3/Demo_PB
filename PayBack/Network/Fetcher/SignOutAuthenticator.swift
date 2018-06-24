//
//  SignOutAuthenticator.swift
//  PayBack
//
//  Created by Dinakaran M on 16/10/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

final internal class SignOutAuthenticator: Fetcher {
    typealias SuccessHandler = ((String) -> Void)?
    fileprivate var successHandler: SuccessHandler = { _ in }
    
    @discardableResult
    func onSuccess(success: SuccessHandler) -> Self {
        self.successHandler = success
        return self
    }
    func logout() {
        let requestBody = RequestBody.getSignOut()
        self.networkFetch(request: RequestFactory.request(requestBody: requestBody))
    }
    override func parse(data: Data) {
        let jsonDecoder = JSONDecoder()
        do {
            let response = try jsonDecoder.decode(AuthenticationSuccess.self, from: data)
            if let msg = response.message {
                self.successHandler!(msg)
            } else {
                self.successHandler!(StringConstant.defaultSuccesseMessage)
            }
        } catch let jsonError {
            print("Logout: Json Parsing Error: \(jsonError)")
            self.successHandler!("")
        }
    }
}
