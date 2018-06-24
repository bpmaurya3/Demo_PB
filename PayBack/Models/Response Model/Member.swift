//
//  Member.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 10/5/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

internal struct Member: Codable {
    let token: String?
    let getmemberdashboard: MemberDashboard?
    let message: String?
    let statusCode: String?
}
internal struct MemberDashboard: Codable {
    let extintAccountBalance: ExtintAccountBalance?
    let extintProfileInfo: ExtintProfileInfo?
    let extintAliasInfo: [ExtintAliasInfo]?
    let extintSubscriptions: ExtintSubscriptions?
    let extintForcePasswordUpdate: String?
    let extintMasterInfo: ExtintMasterInfo?
    let extintContactInfo: ExtintContactInfo?
    let extintMemberEnrollmentDetails: ExtintMemberEnrollmentDetails?
    let extintPostalAddress: ExtintPostalAddress?
    let token: String?
    let message: String?
    let statusCode: String?
}
struct ExtintAccountBalance: Codable {
    let typesLoyaltyCurrency: String?
    let typesTotalPointsAmount: String?
    let typesAvailablePointsAmount: String?
    let typesBlockedPointsAmount: String?
    let typesTotalCollectedPointsAmount: String?
    let typesTotalSpendPointsAmount: String?
    let typesExpiryAnnouncement: TypesExpiryAnnouncement?
}
struct TypesExpiryAnnouncement: Codable {
    let typesPointsToExpireAmount: String?
    let typesNextExpiryDate: String?
}
struct ExtintProfileInfo: Codable {
    let typesGender: String?
    let typesAge: String?
    let typesCountry: String?
    let typesSurroundingArea: TypesSurroundingArea?
}
struct TypesSurroundingArea: Codable {
    let typesAreaKey: String?
    let typesAreaValue: String?
}
struct ExtintAliasInfo: Codable {
    let typesAlias: String?
    let typesAliasType: String?
}
struct ExtintSubscriptions: Codable {
    let typesMarketingPermission: TypesMarketingPermission?
    let typesNewsletterAgreement: TypesNewsletterAgreement?
    let typesSmsAgreement: TypesSmsAgreement?
    let typesSubscription: String?
}
struct TypesMarketingPermission: Codable {
    let typesSubscription: String?
}
struct TypesNewsletterAgreement: Codable {
    let typesSubscription: String?
}
struct TypesSmsAgreement: Codable {
    let typesSubscription: String?
}
struct ExtintMasterInfo: Codable {
    let typesSalutation: String?
    let typesFirstName: String?
    let typesLastName: String?
    let typesDateOfBirth: String?
}
struct ExtintPostalAddress: Codable {
    let typesZipCode: String?
    let typesCity: String?
    let typesRegion: String?
    let typesAdditionalAddress1: String?
    let typesAdditionalAddress2: String?
    let typesExtraAddress1: String?
}
struct ExtintMemberEnrollmentDetails: Codable {
    let typesEnrollmentSource: String?
    let typesPromoCode: String?
    let typesLogoCode: String?
    let typesMemberCard: String?
}
struct ExtintContactInfo: Codable {
    let typesMobileNumber: TypesMobileNumber?
    let typesEmailAddress: TypesEmailAddress?
}
struct TypesMobileNumber: Codable {
    let typesNumber: String?
}
struct TypesEmailAddress: Codable {
    let typesAddress: String?
}
