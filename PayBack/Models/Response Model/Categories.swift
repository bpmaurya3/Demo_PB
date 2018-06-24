//
//  Categories.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 10/12/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

struct Categories: Decodable {
    //Rewards Category
    let categoryList: [RewardsCategory]?
    
    struct RewardsCategory: Decodable {
        let id: String?
        let name: String?
        let iconUrl: String?
    }
    
    //Shop Online categories
    let category: [Category]?
    struct Category: Decodable {
        let id: String?
        let name: String?
        let iconURL: String?
    }
}
