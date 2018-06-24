//
//  BurnProductParamsModel.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 4/3/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import Foundation

struct BurnProductParamsModel {
    let skip: String
    let limit: String
    let searchText: String
    let categoryPath: String
    let minPoints: String
    var maxPoints: String
    let brand: String
    let sort: String
    
    init(skip: String = "0", limit: String = "10", searchText: String = "", categoryPath: String = "", minPoints: String = "", maxPoints: String = StringConstant.MAX_POINTS_RANGE, brand: String = "", sort: String = "") {
        self.skip = skip
        self.limit = limit
        self.searchText = searchText
        self.categoryPath = categoryPath
        self.minPoints = minPoints
        self.maxPoints = maxPoints
        self.brand = brand
        self.sort = sort
    }
}
