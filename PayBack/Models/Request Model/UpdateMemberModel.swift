//
//  UpdateMemberModel.swift
//  PayBack
//
//  Created by Dinakaran M on 24/10/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

struct UpdateMemberModel: Codable {
    var UpdateMemberRequest: UpdateMemberRequest
    init(updateMemberRequest: UpdateMemberRequest) {
        self.UpdateMemberRequest = updateMemberRequest
    }
    struct UpdateMemberRequest: Codable {
        var ConsumerIdentification: ConsumerIdentification
        var Authentication: Authentication
        var MasterInfo: MasterInfo
        var PostalAddress: PostalAddress
        var ContactInfo: ContactInfo
        var AddressValidation: AddressValidation
       
        struct ConsumerIdentification: Codable {
            var ConsumerAuthentication: ConsumerAuthentication
            var DeviceID: String
            init(consumerAuthentication: ConsumerAuthentication, deviceID: String) {
                self.ConsumerAuthentication = consumerAuthentication
                self.DeviceID = deviceID
            }
            struct ConsumerAuthentication: Codable {
                var Principal: String
                var Credential: String
                init(principal: String, credential: String) {
                    self.Principal = principal
                    self.Credential = credential
                }
            }
        }
        struct Authentication: Codable {
            var Token: String
            init(token: String) {
                self.Token = token
            }
        }
        struct MasterInfo: Codable {
            var Salutation: String
            var FirstName: String
            var LastName: String
            var DateOfBirth: String
            init(salutation: String, firstName: String, lastName: String, dateOfBirth: String) {
                self.Salutation = salutation
                self.FirstName = firstName
                self.LastName = lastName
                self.DateOfBirth = dateOfBirth
            }
        }
        struct PostalAddress: Codable {
            var ZipCode: String
            var City: String
            var Region: String
            var AdditionalAddress1: String
            var AdditionalAddress2: String
            var ExtraAddress1: String

            init(zipCode: String, city: String, region: String, additionalAddress1: String, additionalAddress2: String, extraAddress1: String) {
                self.ZipCode = zipCode
                self.City = city
                self.Region = region
                self.AdditionalAddress1 = additionalAddress1
                self.AdditionalAddress2 = additionalAddress2
                self.ExtraAddress1 = extraAddress1
            }
        }
        struct ContactInfo: Codable {
            var MobileNumber: MobileNumber
            var EmailAddress: EmailAddress
            
            struct MobileNumber: Codable {
                var Number: String
                init(number: String) {
                    self.Number = number
                }
            }
            struct EmailAddress: Codable {
                var Address: String
                init(address: String) {
                    self.Address = address
                }
            }
        }
        struct AddressValidation: Codable {
            var PostalAddressValidation: String
            init(postalAddressValidation: String) {
                self.PostalAddressValidation = postalAddressValidation
            }
        }

    }
}
