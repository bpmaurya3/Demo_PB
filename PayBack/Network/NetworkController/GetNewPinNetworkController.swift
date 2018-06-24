//
//  GetNewPinNetworkController.swift
//  PayBack
//
//  Created by Dinakaran M on 12/10/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

final internal class GetNewPinNetworkController {
    var forgotPinAuthenticator = PinAuthenticator()

    typealias SuccessHandler = ((String) -> Void)?
    typealias ErrorHandler = ((String) -> Void)?

    fileprivate var successHandler: SuccessHandler = { _ in }
    fileprivate var errorHandler: ErrorHandler = { _ in }
    fileprivate var tokenExpiredHandler: (() -> Void) = { }

    @discardableResult
    func onSuccess(success: SuccessHandler) -> Self {
        self.successHandler = success
        return self
    }
    @discardableResult
    func onError(error: ErrorHandler) -> Self {
        self.errorHandler = error
        return self
    }
    @discardableResult
    func onTokenExpired(tokenExpired: @escaping (() -> Void)) -> Self {
        self.tokenExpiredHandler = tokenExpired
        return self
    }
    func generateOTP(withMobileNo alias: String) {
        forgotPinAuthenticator
            .onTokenExpired(tokenExpired: tokenExpiredHandler)
            .onSuccess { [weak self] (successMsg) in
                self?.successHandler!(successMsg)
            }
            .onError { [weak self] (error) in
                self?.errorHandler!(error)
            }
            .generateOTPPin(withMobileNo: alias)
    }
    func getPIN(alias: String, otp: String, dob: String) {
        forgotPinAuthenticator
            .onTokenExpired(tokenExpired: tokenExpiredHandler)
            .onSuccess { [weak self] (successMsg) in
                self?.successHandler!(successMsg)
            }
            .onError { [weak self] (error) in
                self?.errorHandler!(error)
            }
            .getPin(alias: alias, otp: otp, dob: dob)
    }

    func getChangedPin(oldSecretPin: String, newSecretPin: String) {
        forgotPinAuthenticator
            .onTokenExpired(tokenExpired: tokenExpiredHandler)
            .onSuccess { [weak self] (successMsg) in
                self?.successHandler!(successMsg)
            }
            .onError { [weak self] (error) in
                self?.errorHandler!(error)
            }
            .getChangedPin(oldSecretPin: oldSecretPin, newSecretPin: newSecretPin)
    }
}
