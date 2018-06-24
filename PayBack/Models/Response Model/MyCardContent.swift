//
//  MyCardContent.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 4/3/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import Foundation

struct MyCardContent: Decodable {
    let myCardDetails: MyCardDetails?
    
    struct MyCardDetails: Decodable {
        let myCardImage: String?
        let showLCN: Bool?
        let showFirstName: Bool?
    }
}
