//
//  GetMemberDashboardModel.swift
//  PayBack
//
//  Created by Dinakaran M on 17/10/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

struct GetMemberDashboardModel: Codable {
    var GetMemberDashboardRequest: GetMemberDashboardRequest
    init(getMemberDashboardRequest: GetMemberDashboardRequest) {
        self.GetMemberDashboardRequest = getMemberDashboardRequest
    }
    struct GetMemberDashboardRequest: Codable {
        var Authentication: Authentication
        var SendEnrollmentDetails: String
        init(authentication: Authentication, sendEnrollmentDetails: String) {
            self.Authentication = authentication
            self.SendEnrollmentDetails = sendEnrollmentDetails
        }
        struct Authentication: Codable {
            var Token: String
            init(token: String) {
                self.Token = token
            }
        }
    }
}
