//
//  UserProfileUtilities.swift
//  PayBack
//
//  Created by Dinakaran M on 27/10/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class UserProfileUtilities {

}
extension UserProfileUtilities {
    static func getPath() -> String {
        // getting path for UserProfile.plist
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths.object(at: 0) as? NSString
        let path = documentsDirectory?.appendingPathComponent("UserProfile.plist")
        
        let fileManager = FileManager.default
        //check if file exists
        if !fileManager.fileExists(atPath: path!) {
         let bundlePath = Bundle.main.path(forResource: "UserProfile", ofType: "plist")
            do {
                try fileManager.copyItem(atPath: bundlePath!, toPath: path!)
            } catch let error as NSError {
                print("Unable to copy file. ERROR: \(error.localizedDescription)")
            }
        }
        return path!
    }
    // Save
    //swiftlint:disable function_body_length
    //swiftlint:disable cyclomatic_complexity
    static func setUserProfile(forMemberDetails member: MemberDashboard) {
        if let firstName = member.extintMasterInfo?.typesFirstName {
            self.setUserData(withKeyandValue: kFirstName, value: firstName)
        }
        if let lastName = member.extintMasterInfo?.typesLastName {
            self.setUserData(withKeyandValue: kLastName, value: lastName)
        }
        if let points = member.extintAccountBalance?.typesTotalPointsAmount {
            self.setUserData(withKeyandValue: kTotalPoints, value: points)
        } else {
            self.setUserData(withKeyandValue: kTotalPoints, value: "0")
        }
        if let avlPoints = member.extintAccountBalance?.typesAvailablePointsAmount {
            self.setUserData(withKeyandValue: kAvailablePoints, value: avlPoints)
        }
        if let blockedPoints = member.extintAccountBalance?.typesBlockedPointsAmount {
            self.setUserData(withKeyandValue: kBlockedPoints, value: blockedPoints)
        }
        if let expirePoints = member.extintAccountBalance?.typesExpiryAnnouncement?.typesPointsToExpireAmount {
            self.setUserData(withKeyandValue: kExpirePoints, value: expirePoints)
        }
        if let email = member.extintContactInfo?.typesEmailAddress?.typesAddress {
            self.setUserData(withKeyandValue: kEmailAddress, value: email)
        }
//        if let mobilenumber = member.extintContactInfo?.typesMobileNumber?.typesNumber {
//            self.setUserData(withKeyandValue: kMobileNumber, value: mobilenumber)
//        }
        if let aliasInfo = member.extintAliasInfo {
            for aliasInfo in aliasInfo where aliasInfo.typesAliasType == StringConstant.aliasTypeMobileNumber {
                if let mobileNumber = aliasInfo.typesAlias {
                   self.setUserData(withKeyandValue: kMobileNumber, value: mobileNumber)
                }
            }
        }
        if let aliasInfo = member.extintAliasInfo {
            for aliasInfo in aliasInfo where aliasInfo.typesAliasType == StringConstant.aliasTypeCardNumber {
                if let cardNumber = aliasInfo.typesAlias {
                    self.setUserData(withKeyandValue: kCardNumber, value: cardNumber)
                    self.setUserData(withKeyandValue: kUserID, value: cardNumber)
                }
            }
        }
        
        if let dob = member.extintMasterInfo?.typesDateOfBirth {
            self.setUserData(withKeyandValue: kDateOfBirth, value: dob)
        }
        if let pincode = member.extintProfileInfo?.typesSurroundingArea?.typesAreaValue {
            self.setUserData(withKeyandValue: kPinCode, value: pincode)
        }
        if let salutation = member.extintMasterInfo?.typesSalutation {
            self.setUserData(withKeyandValue: kSalutation, value: salutation)
        }
        if let zipcode = member.extintPostalAddress?.typesZipCode {
            self.setUserData(withKeyandValue: kZipcode, value: zipcode)
        }
        if let city = member.extintPostalAddress?.typesCity {
            self.setUserData(withKeyandValue: kCity, value: city)
        }
        if let region = member.extintPostalAddress?.typesRegion {
            self.setUserData(withKeyandValue: kRegion, value: region)
        }
        if let address1 = member.extintPostalAddress?.typesAdditionalAddress1 {
            self.setUserData(withKeyandValue: kAddress1, value: address1)
        }
        if let address2 = member.extintPostalAddress?.typesAdditionalAddress2 {
            self.setUserData(withKeyandValue: kAddress2, value: address2)
        }
        if let extraAddress = member.extintPostalAddress?.typesExtraAddress1 {
            self.setUserData(withKeyandValue: kExtraAddress1, value: extraAddress)
        }
    }
    //swiftlint:enable function_body_length
    //swiftlint:enable cyclomatic_complexity
    static func setUserData(withKeyandValue key: String, value: String) {
        let plistPath = getPath()
        if FileManager.default.fileExists(atPath: plistPath) {
            let userDetails = NSMutableDictionary(contentsOfFile: plistPath)!
            userDetails.setValue(value, forKey: key)
            userDetails.write(toFile: plistPath, atomically: true)
        }
    }
    static func clearUserDetails() {
        let plistPath = getPath()
        if FileManager.default.fileExists(atPath: plistPath) {
            let userDetails = NSMutableDictionary(contentsOfFile: plistPath)!
            userDetails.removeAllObjects()
            userDetails.write(toFile: plistPath, atomically: true)
        }
    }
    static func clearUserDefault() {
        UserProfileUtilities.setValueForKeyInUserDefaults(forKey: kIsUserLoged, andValue: false)
        UserProfileUtilities.setValueForKeyInUserDefaults(forKey: kSessionToken, andValue: "")
    }
    
    // getData
    static func getUserDetails() -> UserProfileModel? {
        let plistPath = getPath()
        if FileManager.default.fileExists(atPath: plistPath) {
            if let userDatas = NSMutableDictionary(contentsOfFile: plistPath) as? [String: Any] {
                let jsonDecoder = JSONDecoder()
                do {
                    let jsonData = try? JSONSerialization.data(withJSONObject: userDatas, options: [])
                    let  member = try jsonDecoder.decode(UserProfileModel.self, from: jsonData!)
                    return member
                    
                } catch let jsonError {
                    print("User Details: Json Parsing Error: \(jsonError)")
                }
            }
        }
        return nil
    }
}
// User Defaults
extension UserProfileUtilities {
    static func setValueForKeyInUserDefaults(forKey key: String, andValue value: Any) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key)
    }
    static func getValueFromUserDefaultsForKey(forKey key: String) -> Any {
        let defaults = UserDefaults.standard
        if let retuenValue = defaults.object(forKey: key) {
            return retuenValue
        } else {
            return ""
        }
    }
    static func getBoolValueFromUserDefaultsForKey(forKey key: String) -> Bool {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: key)
    }
    static func getAuthenticationToken() -> String {
        let defaults = UserDefaults.standard
        if let token = defaults.object(forKey: kSessionToken) {
            return (token as? String)!
        } else {
            return ""
        }
    }
    static func getUserID() -> String {
        guard let userid = (self.getUserDetails()?.UserID)  else {
            return ""
        }
        return userid
    }
    static func getUserCardnumber() -> String {
        guard let card = (self.getUserDetails()?.CardNumber)  else {
            return ""
        }
        return card
    }
}

// User Percentage
extension UserProfileUtilities {
   static func userPercentage() -> Int {
        if let userDetails = UserProfileUtilities.getUserDetails() {
            var dataElementCount = 0
            if let fName = userDetails.FirstName, fName.isNotEmpty() {
                dataElementCount += 1
            }
            if let lName = userDetails.LastName, lName.isNotEmpty() {
                dataElementCount += 1
            }
            if let email = userDetails.EmailAddress, email.isNotEmpty() {
                dataElementCount += 1
            }
            if let mobileNumber = userDetails.MobileNumber, mobileNumber.isNotEmpty() {
                dataElementCount += 1
            }
            if let dob = userDetails.DateOfBirth, dob.isNotEmpty() {
                dataElementCount += 1
            }
            if let pin = userDetails.PinCode, pin.isNotEmpty() {
                dataElementCount += 1
            }
            if let address = userDetails.Address1, address.isNotEmpty(), let address2 = userDetails.Address2, address2.isNotEmpty(), let city = userDetails.City, city.isNotEmpty(), let state = userDetails.Region, state.isNotEmpty() {
                dataElementCount += 1
            }
           return Int((100.0 / 7.0) * Double(dataElementCount))
        }
        return 0
    }
}
