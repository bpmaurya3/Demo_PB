//
//  ChangePinModel.swift
//  PayBack
//
//  Created by Dinakaran M on 25/10/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

struct ChangePinModel: Codable {
    var ChangePasswordRequest: ChangePasswordRequest
    init(changePasswordRequest: ChangePasswordRequest) {
        self.ChangePasswordRequest = changePasswordRequest
    }
    struct ChangePasswordRequest: Codable {
        var ConsumerIdentification: ConsumerIdentification
        var Authentication: Authentication
        var oldSecret: OldSecret
        var newSecret: NewSecret
        init(consumerIdentification: ConsumerIdentification, authentication: Authentication, OldSecret: OldSecret, NewSecret: NewSecret) {
            self.ConsumerIdentification = consumerIdentification
            self.Authentication = authentication
            self.oldSecret = OldSecret
            self.newSecret = NewSecret
        }
        struct ConsumerIdentification: Codable {
            var Principal: String
            var Credential: String
            init(principal: String, credential: String) {
                self.Principal = principal
                self.Credential = credential
            }
        }
        struct Authentication: Codable {
            var Token: String
            init(token: String) {
                self.Token = token
            }
        }
        struct OldSecret: Codable {
            var SecretType: String
            var Secret: String
            init(secretType: String, secret: String) {
                self.SecretType = secretType
                self.Secret = secret
            }
        }
        struct NewSecret: Codable {
            var SecretType: String
            var Secret: String
            init(secretType: String, secret: String) {
                self.SecretType = secretType
                self.Secret = secret
            }
        }
    }
}
