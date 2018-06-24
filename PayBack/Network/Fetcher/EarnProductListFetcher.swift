//
//  EarnProductListFetcher.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 10/13/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

final internal class EarnProductListFetcher: Fetcher {
    fileprivate var successHandler: ((CategoryProduct) -> Void)?
    
    func onSuccess(success: @escaping (CategoryProduct) -> Void) -> Self {
        self.successHandler = success
        
        return self
    }
    
    func fetchProductList(withParams params: EarnProductListParamsTuple) {
         let requestBody = RequestBody.getEarnMobileSearch(searchText: params.searchText, page: params.page, per_page: params.per_page, filter: params.filter, sortBy: params.sortBy)
        self.networkFetch(request: RequestFactory.request(requestBody: requestBody))
    }
    
    override func parse(data: Data) {
        let jsonDecoder = JSONDecoder()
        do {
            let result = try jsonDecoder.decode(CategoryProduct.self, from: data)
            successHandler!(result)
            
        } catch let jsonError {
            print("EarnProductListFetcher: Json Parsing Error: \(jsonError)")
        }
    }
}
