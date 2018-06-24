//
//  LinkMobileRequestModel.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 4/2/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import Foundation
// Link Mobile
struct LinkMobileRequestModel: Encodable {
    let LinkMobileRequest: LinkMobileRequest
    
    init(linkMobileRequest: LinkMobileRequest) {
        self.LinkMobileRequest = linkMobileRequest
    }
    
    struct LinkMobileRequest: Encodable {
        let ConsumerIdentification: ConsumerIdentification
        let Authentication: Authentication
        let OTP: String
        let MobileNumber: String
        init(consumerIdentification: ConsumerIdentification, authentication: Authentication, otp: String, mobileNumber: String ) {
            self.ConsumerIdentification = consumerIdentification
            self.Authentication = authentication
            self.OTP = otp
            self.MobileNumber = mobileNumber
        }
    }
}
// Generate OTP
struct GenrateOTPForLinkMobileRequestModel: Encodable {
    let GenerateOTPRequest: GenerateOTPRequest
    
    init(generateOTPRequest: GenerateOTPRequest) {
        self.GenerateOTPRequest = generateOTPRequest
    }
    
    struct GenerateOTPRequest: Encodable {
        let ConsumerIdentification: ConsumerIdentification
        let Authentication: Authentication
        let MobileNumber: String
        init(consumerIdentification: ConsumerIdentification, authentication: Authentication, mobileNumber: String ) {
            self.ConsumerIdentification = consumerIdentification
            self.Authentication = authentication
            self.MobileNumber = mobileNumber
        }
    }
}

// Common
struct Authentication: Encodable {
    let Token: String
    init(token: String) {
        self.Token = token
    }
}
struct ConsumerIdentification: Encodable {
    let  ConsumerAuthentication: ConsumerAuthentication
    let Partner: Partner
    let DeviceID: String = "11"
    let Product: String = "11"
    let Version: String = "11"
    
    init(consumerAuthentication: ConsumerAuthentication = ConsumerAuthentication(), partner: Partner = Partner()) {
        self.Partner = partner
        self.ConsumerAuthentication = consumerAuthentication
    }
    struct ConsumerAuthentication: Encodable {
        let Principal: String = "11"
        let Credential: String = "11"
        init() {}
    }
    struct Partner: Encodable {
        let PartnerShortName: String = "11"
        let BusinessUnitShortName: String = "11"
        let BranchShortName: String = "11"
        init() {}
    }
}
