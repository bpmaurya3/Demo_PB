//
//  Insurance.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 11/2/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

struct InsuranceTypes: Decodable {
    let errorMessage: String?
    let errorCode: String?
    
    let iconGridView: [IconGridView]?
    
    let tileImageGridElements: [IconGridView]?
    
    struct IconGridView: Decodable {
        let imagePath: String?
        let title: String?
        let redirectionURL: String?
        let filterTags: String?
    }
    
    let tagImageGridElement: [TagImageGridElement]?
    
    struct TagImageGridElement: Decodable {
        let title: String?
        let imagePath: String?
        let parentTag: String?
        let ownTag: String?
    }
}
