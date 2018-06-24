//
//  SignupImageGridModel.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 1/19/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import Foundation

struct SignupImageGridModel: Decodable {
    let errorCode: String?
    let errorMessage: String?
    
    let imageGridWithTitle: ImageGridWithTitle?
    
    struct ImageGridWithTitle: Decodable {
        let title: String?
        let imageGridDetails: [ImageGridDetails]?
        
        struct ImageGridDetails: Decodable {
            let imagegridtitle: String?
            let imagePath: String?
        }
    }
}
