//
//  AuthenticationModel.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 9/25/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

struct AuthenticationModel: Codable {
    var AuthenticateRequest: AuthenticateRequestStruct
   
     init(authenticationRequest: AuthenticateRequestStruct) {
        self.AuthenticateRequest = authenticationRequest
    }
}

struct AuthenticateRequestStruct: Codable {
    var Authentication: AuthenticationStruct
    
    init(authentiction: AuthenticationStruct) {
        self.Authentication = authentiction
    }
}

struct AuthenticationStruct: Codable {
    var Identification: IdentificationStruct
    var Security: SecurityStruct
    
    init(identity: IdentificationStruct, security: SecurityStruct) {
        self.Identification = identity
        self.Security = security
    }
}

struct IdentificationStruct: Codable {
    var Alias: String
    var AliasType: String
    
    init(alias: String, aliasType: String) {
        self.Alias = alias
        self.AliasType = aliasType
    }
}

struct SecurityStruct: Codable {
    var SecretType: String
    var Secret: String
    
    init(secret: String, secretType: String) {
        self.Secret = secret
        self.SecretType = secretType
    }
}
