//
//  InstoreListModel.swift
//  PayBack
//
//  Created by valtechadmin on 4/24/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import Foundation

struct InstoreListModel: Decodable {
    let deals: [Deals]?
    let filters: [StoreLocaterFilter]?
    
    struct Deals: Decodable {
        let id: String?
        let title: String?
        let description: String?
        let image: String?
        let distance: Double?
        let brand: String?
        let category: String?
        let city: String?
        let locations: [Location]?
        let url: String?
        
    }
}

struct Location: Decodable, Equatable {
   
    let latitude: String?
    let longitude: String?
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        if lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude {
            return true
        }
        return false
    }
    
}

struct StoreLocaterFilter: Decodable {
    let type: String?
    let displayName: String?
    let facets: [Facets]?
}

struct Facets: Decodable {
    let name: String?
}
