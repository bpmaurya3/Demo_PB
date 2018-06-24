//
//  StaticWebContentModel.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 1/31/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import Foundation

struct StaticWebContentModel: Decodable {
    let staticWebContentElements: [StaticWebContentElements]?
    
    struct StaticWebContentElements: Decodable {
        let staticWebCntText: String?
        let staticWebCntURL: String?
    }
}
