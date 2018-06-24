//
//  TopTrendFetcher.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 11/30/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation
final class TopTrendFetcher: Fetcher {
    fileprivate var successHandler: ((TopTrend) -> Void)?
    
    func onSuccess(success: @escaping (TopTrend) -> Void) -> Self {
        self.successHandler = success
        
        return self
    }
    
    func fetchTopTrend(withParams params: ShopOnlineProductParamsModel) {
        let requestBody = RequestBody.getTopTrendParams(params: params)
        self.networkFetch(request: RequestFactory.request(requestBody: requestBody))
    }
    
    override func parse(data: Data) {
        let jsonDecoder = JSONDecoder()
        do {
            let topTrend = try jsonDecoder.decode(TopTrend.self, from: data)
            successHandler!(topTrend)
        } catch let jsonError {
            print("Top Trend: Json Parsing Error: \(jsonError)")
        }
    }
}
