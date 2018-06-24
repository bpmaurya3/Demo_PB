//
//  ShopOnlineShowCaseCategoryFetcher.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 4/3/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import Foundation
final internal class ShopOnlineShowCaseCategoryFetcher: Fetcher {
    fileprivate var successHandler: ((ShowCaseCategory) -> Void)?
    
    func onSuccess(success: @escaping (ShowCaseCategory) -> Void) -> Self {
        self.successHandler = success
        
        return self
    }
    
    func fetch() {
        self.networkFetch(request: RequestFactory.showcaseCategories())
    }
    
    override func parse(data: Data) {
        let jsonDecoder = JSONDecoder()
        do {
            let result = try jsonDecoder.decode(ShowCaseCategory.self, from: data)
            successHandler!(result)
        } catch let jsonError {
            print("OnlineOffersFetcher: Json Parsing Error: \(jsonError)")
            errorHandler(jsonError.localizedDescription)
        }
    }
}
