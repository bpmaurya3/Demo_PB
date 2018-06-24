//
//  SearchFetcher.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 10/11/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

final internal class SearchFetcher: Fetcher {
    fileprivate var successHandler: (([AutoSearchedItem]) -> Void)?
    
    func onSuccess(success: @escaping ([AutoSearchedItem]) -> Void) -> Self {
        self.successHandler = success
        
        return self
    }
    
    func search(searchType: String, searchText: String) {
        let requestBody = RequestBody.getAutoSearch(searchType: searchType, searchText: searchText)
        self.networkFetch(request: RequestFactory.request(requestBody: requestBody))
    }
    
    override func parse(data: Data) {
        
        let jsonDecoder = JSONDecoder()
        do {
            let resultArray = try jsonDecoder.decode([AutoSearchedItem].self, from: data)
            successHandler!(resultArray)
            
        } catch let jsonError {
            print("SearchFetcher: Json Parsing Error: \(jsonError)")
            errorHandler(jsonError.localizedDescription)
        }
    }
}
