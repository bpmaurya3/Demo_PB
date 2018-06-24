//
//  SignOutRequestModel.swift
//  PayBack
//
//  Created by Dinakaran M on 16/10/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

struct SignOutRequestModel: Codable {
    var LogoutRequest: LogoutRequest
    init(logoutRequest: LogoutRequest) {
        self.LogoutRequest = logoutRequest
    }
    struct LogoutRequest: Codable {
        var authtoken: String
        init(authtoken: String) {
            self.authtoken = authtoken
        }
    }
}
