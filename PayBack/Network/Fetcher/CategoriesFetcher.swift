//
//  CategoriesFetcher.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 10/12/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

final internal class CategoriesFetcher: Fetcher {
    fileprivate var successHandler: ((Categories) -> Void)?
    
    func onSuccess(success: @escaping (Categories) -> Void) -> Self {
        self.successHandler = success
        
        return self
    }
    func fetchCategoriesForShopOnline() {
        let requestBody = RequestBody.getShopOnlineCategory()
        self.networkFetch(request: RequestFactory.request(requestBody: requestBody))
    }
    
    func fetchCategoriesForReward(withParams params: Data) {
        self.networkFetch(request: RequestFactory.request(requestBody: params))
    }
    
    override func parse(data: Data) {

        let jsonDecoder = JSONDecoder()
        do {
            let resultArray = try jsonDecoder.decode(Categories.self, from: data)
            successHandler!(resultArray)
            
        } catch let jsonError {
            print("CategoriesFetcher: Json Parsing Error: \(jsonError)")
        }
        
    }
}
