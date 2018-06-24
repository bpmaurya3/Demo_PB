//
//  SearchTVCellModel.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 10/11/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

internal class SearchTVCellModel {
    var itemName: String?
    var itemId: String?
    
    internal init(name: String? = nil, itemId: String = "") {
        self.itemName = name
        self.itemId = itemId
    }
    
    internal init(withSearchResult result: AutoSearchedItem) {
        self.itemName = result.label
        self.itemId = result.id
    }
}
