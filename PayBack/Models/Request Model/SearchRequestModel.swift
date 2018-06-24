//
//  File.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 10/11/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

struct SearchRequestModel: Encodable {
    let type: String
    let searchType: String
    let data: Data
    
    init(type: String, searchType: String, data: Data) {
        self.type = type
        self.searchType = searchType
        self.data = data
    }
    
    struct Data: Encodable {
        let pid: String
        let key: String
        let term: String
        
        init(pid: String = "pb", key: String = "pr8bs5nqbru2b", searchText: String) {
            self.pid = pid
            self.key = key
            self.term = searchText
        }
    }
}
