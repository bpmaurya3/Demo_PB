//
//  ExplorePayback.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 5/31/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import Foundation

struct ExplorePayback: Decodable {
    let pbexplore: PBexplore?
    
    struct PBexplore: Decodable {
        let carousel: [Carousels]?
        let expired: Bool?
        let vedioDetails: [VedioDetails]?
    }
    struct VedioDetails: Decodable {
        let title: String?
        let subTitle: String?
        let ctaButtonTxt: String?
        let ctaButtonDesc: String?
        let videoID: String?
    }
}
