//
//  MyTransactionsRequestModel.swift
//  PayBack
//
//  Created by Dinakaran M on 26/10/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

struct MyTransactionsRequestModel: Codable {
    let type: String
    let filter: Filter
    let GetAccountTransactionsRequest: GetAccountTransactionsRequest
    init(type: String = "SearchAccountTransactionsMobile", filter: Filter, getAccountTransactionsRequest: GetAccountTransactionsRequest) {
        self.type = type
        self.filter = filter
        self.GetAccountTransactionsRequest = getAccountTransactionsRequest
    }
    struct Filter: Codable {
        let partnerBrand: String
        let transactionType: String
        let fromDate: String
        let toDate: String
        init(partnerBrand: String, transactionType: String, fromDate: String, toDate: String) {
            self.partnerBrand = partnerBrand
            self.transactionType = transactionType
            self.fromDate = fromDate
            self.toDate = toDate
        }
    }
    struct GetAccountTransactionsRequest: Codable {
        let ConsumerIdentification: ConsumerIdentification
        let Authentication: Authentication
        let Pagination: Pagination
        init(consumerIdentification: GetAccountTransactionsRequest.ConsumerIdentification, authentication: Authentication, pagination: Pagination) {
            self.ConsumerIdentification = consumerIdentification
            self.Authentication = authentication
            self.Pagination = pagination
        }
        struct ConsumerIdentification: Codable {
            let ConsumerAuthentication: ConsumerAuthentication
            init(consumerAuthentication: ConsumerAuthentication) {
                self.ConsumerAuthentication = consumerAuthentication
            }
            struct ConsumerAuthentication: Codable {
                let Principal: String
                let Credential: String
                init(principal: String, credential: String) {
                    self.Principal = principal
                    self.Credential = credential
                }
            }
        }
        struct Authentication: Codable {
            let Token: String
            init(token: String) {
                self.Token = token
            }
        }
        struct Pagination: Codable {
            let PageNo: String
            let PageSize: String
            init(page: String, pageSize: String) {
                self.PageNo = page
                self.PageSize = pageSize
            }
        }
    }
}
