//
//  ShowCaseCategories.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 4/3/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import Foundation
struct ShowCaseCategory: Decodable {
    let showCaseCategories: [ShowCaseCategories]?
    
    struct ShowCaseCategories: Decodable {
        let categoryID: String?
        let categoryName: String?
    }
}
