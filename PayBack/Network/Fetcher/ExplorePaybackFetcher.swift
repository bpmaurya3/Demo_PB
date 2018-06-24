//
//  ExplorePaybackFetcher.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 5/31/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import Foundation

final internal class ExplorePaybackFetcher: Fetcher {
    fileprivate var successHandler: ((ExplorePayback) -> Void)?
    
    func onSuccess(success: @escaping (ExplorePayback) -> Void) -> Self {
        self.successHandler = success
        
        return self
    }
    
    func fetchExplorePayback() {
        self.networkFetch(request: RequestFactory.explorePayback())
    }
    
    override func parse(data: Data) {
        let jsonDecoder = JSONDecoder()
        do {
            let resultArray = try jsonDecoder.decode(ExplorePayback.self, from: data)
            successHandler!(resultArray)
        } catch let jsonError {
            print("CouponsFetcher: Json Parsing Error: \(jsonError)")
            errorHandler(jsonError.localizedDescription)
        }
    }
}
