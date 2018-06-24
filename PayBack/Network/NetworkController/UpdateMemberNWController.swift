//
//  UpdateMemberNWController.swift
//  PayBack
//
//  Created by Dinakaran M on 25/10/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

final internal class UpdateMemberNWController {
    var updateMemberFetcher = UpdateMemberFetcher()
    
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
    func onTokenExpired(tokenExpired: @escaping (() -> Void)) -> Self {
        self.tokenExpiredHandler = tokenExpired
        return self
    }
    func updateMemberDetails(withParameter params: UserProfileModel) {
        updateMemberFetcher
            .onTokenExpired(tokenExpired: tokenExpiredHandler)
            .onSuccess(success: { [weak self] (successMsg) in
                 self?.successHandler!(successMsg)
            })
            .onError(error: { [weak self] (error) in
                self?.errorHandler!(error)
            })
            .updateMemberDetails(withData: params)
    }
    func generateOTPForLinkMobile(withMobileNo mobileNo: String, token: String) {
        updateMemberFetcher
            .onTokenExpired(tokenExpired: tokenExpiredHandler)
            .onSuccess { [weak self] (successMsg) in
                self?.successHandler!(successMsg)
            }
            .onError { [weak self] (error) in
                self?.errorHandler!(error)
            }
            .generateOTPForLinkMobile(withMobileNo: mobileNo, token: token)
    }
    func linkMobile(mobileNo: String, otp: String, token: String) {
        updateMemberFetcher
            .onTokenExpired(tokenExpired: tokenExpiredHandler)
            .onSuccess { [weak self] (successMsg) in
                self?.successHandler!(successMsg)
            }
            .onError { [weak self] (error) in
                self?.errorHandler!(error)
            }
            .linkMobile(mobileNo: mobileNo, otp: otp, token: token)
    }

}
