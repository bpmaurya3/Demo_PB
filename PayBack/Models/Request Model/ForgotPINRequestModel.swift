//
//  ForgotPINRequestModel.swift
//  PayBack
//
//  Created by Dinakaran M on 13/10/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

struct GenerateOTPRequestModel: Codable {
    let GenerateOTPForPIN: GenerateOTPForPIN
    init(generateOTPForPIN: GenerateOTPForPIN) {
        self.GenerateOTPForPIN = generateOTPForPIN
    }
    struct GenerateOTPForPIN: Codable {
        let AliasNumber: String
        init(aliasNumber: String) {
            self.AliasNumber = aliasNumber
        }
    }
}
struct ForgotPINRequestModel: Codable {
    let ForgotPINRequest: ForgotPINRequest
    init(forgotPinRequest: ForgotPINRequest) {
        self.ForgotPINRequest = forgotPinRequest
    }
    struct ForgotPINRequest: Codable {
        let OTP: String
        let AliasNumber: String
        let DateOfBirth: String
        init(otp: String, alisaNumber: String, dateOfBirth: String) {
            self.OTP = otp
            self.AliasNumber = alisaNumber
            self.DateOfBirth = dateOfBirth
        }
    }
}
