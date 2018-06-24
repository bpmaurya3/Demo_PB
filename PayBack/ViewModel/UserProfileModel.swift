//
//  UserProfileModel.swift
//  PayBack
//
//  Created by Dinakaran M on 27/10/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

internal struct UserProfileModel: Codable {
        
        let LastName: String?
        let FirstName: String?
        let TotalPoints: String?
        let AvailablePoints: String?
        let BlockedPoints: String?
        let PointsToExpireAmount: String?
        let UserLoged: String?
        let EmailAddress: String?
        let MobileNumber: String?
        let CardNumber: String?
        let DateOfBirth: String?
        let PinCode: String?
        let Salutation: String?
        let ZipCode: String?
        let City: String?
        let Region: String?
        let Address1: String?
        let Address2: String?
        let ExtraAddress: String?
        let UserID: String?
        let addressSplitModel: AddressSplitCellModel?
}
