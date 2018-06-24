//
//  UpdateMemberFetcher.swift
//  PayBack
//
//  Created by Dinakaran M on 25/10/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation
final internal class UpdateMemberFetcher: Fetcher {
    typealias SuccessHandler = ((String) -> Void)?
    fileprivate var successHandler: SuccessHandler = { _ in }
    
    @discardableResult
    func onSuccess(success: SuccessHandler) -> Self {
        self.successHandler = success
        return self
    }
    func updateMemberDetails(withData params: UserProfileModel) {
        let requestBody = RequestBody.updateMemberDetails(params: params)
        self.networkFetch(request: RequestFactory.request(requestBody: requestBody))
    }
    func generateOTPForLinkMobile(withMobileNo mobileNo: String, token: String) {
        let requestBody = RequestBody.generateOTPForLinkMobile(mobileNo: mobileNo, token: token)
        self.networkFetch(request: RequestFactory.request(requestBody: requestBody))
        
    }
    func linkMobile(mobileNo: String, otp: String, token: String) {
        let requestBody = RequestBody.linkMobile(mobileNo: mobileNo, otp: otp, token: token)
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
            print("Update Member: Json Parsing Error: \(jsonError)")
        }
    }
}
