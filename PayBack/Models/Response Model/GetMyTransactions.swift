//
//  GetMyTransactions.swift
//  PayBack
//
//  Created by Dinakaran M on 26/10/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

struct GetMyTransactions: Codable {
    let extintAccountTransactionEvent: [ExtintAccountTransactionEvent]?
    let extintTotalResultSize: String?
    let message: String?
    let statusCode: String?
    
    struct ExtintAccountTransactionEvent: Codable {
        let typesPartner: TypesPartner?
        let typesActivityDate: String?
        let typesReceiptNumber: String?
        let typesAlias: TypesAlias?
        let typesEventCategory: String?
        let typesAccountTransactionDetails: TypesAccountTransactionDetails?
        
        struct TypesPartner: Codable {
            let typesPartnerShortName: String?
            let typesPartnerDisplayName: String?
        }
        struct TypesAlias: Codable {
            let typesAlias: String?
            let typesAliasType: String?
        }
        struct TypesAccountTransactionDetails: Codable {
            let typesDescription: String?
            let typesValue: TypesValue?
            let typesAddDate: String?
            
            struct TypesValue: Codable {
                let typesLoyaltyAmount: String?
            }
        }
    }
}

struct TransactionsRedeemNavDetails: Codable {
    let navPageDetails: NavPageDetail?
    
    struct NavPageDetail: Codable {
        let ctaButtonTxt: String?
        let navigateTo: String?
    }
}
