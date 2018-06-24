//
//  OnlineOffersModel.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 2/10/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import Foundation

struct OnlineOffersModel: Decodable {
    let offerzoneDeals: OfferzoneDeals?
    
    struct OfferzoneDeals: Decodable {
        let results: [Results]?
        let totalCount: Int?
        let filters: [ProductFilter]?
    }
    struct Results: Decodable {
        let itemType: String?
        let id: String?
        let url: String?
        let img: String?
        let store: String?
        let storeLogo: String?
        let pbStoreData: PBStoreData?
    }
}
