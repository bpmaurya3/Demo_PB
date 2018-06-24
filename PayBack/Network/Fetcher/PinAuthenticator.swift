//
//  PinAuthenticator.swift
//  PayBack
//
//  Created by Dinakaran M on 12/10/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

final internal class PinAuthenticator: Fetcher {

    typealias SuccessHandler = ((String) -> Void)?
    fileprivate var successHandler: SuccessHandler = { _ in }
    
    @discardableResult
    func onSuccess(success: SuccessHandler) -> Self {
        self.successHandler = success
        return self
    }
    func generateOTPPin(withMobileNo alias: String) {
        let requestBody = RequestBody.generateOTP(aliasNumber: alias)
        self.networkFetch(request: RequestFactory.request(requestBody: requestBody))
    }
    func getPin(alias: String, otp: String, dob: String) {
        let requestBody = RequestBody.forgotPin(otp: otp, alisaNumber: alias, dateOfBirth: dob)
        self.networkFetch(request: RequestFactory.request(requestBody: requestBody))
    }
    func getChangedPin(oldSecretPin: String, newSecretPin: String) {
        let requestBody = RequestBody.changePin(oldSecretPin: oldSecretPin, newSecretPin: newSecretPin)
        self.networkFetch(request: RequestFactory.request(requestBody: requestBody))
    }
    override func parse(data: Data) {
        let jsonDecoder = JSONDecoder()
        do {
            let response = try jsonDecoder.decode(AuthenticationSuccess.self, from: data)
            if let typeCodeMsg = response.message {
                self.successHandler!(typeCodeMsg)
            }
        } catch let jsonError {
            print("Pin: Json Parsing Error: \(jsonError)")
        }
    }
}
