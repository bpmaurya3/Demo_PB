//
//  CouponsFetcher.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 5/25/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import Foundation
final internal class CouponsFetcher: Fetcher {
    fileprivate var successHandler: ((Coupons) -> Void)?
    
    func onSuccess(success: @escaping (Coupons) -> Void) -> Self {
        self.successHandler = success
        
        return self
    }
    
    func fetchCoupons(page: String, per_page: String = "10", filer: [String: String]) {
        let requestData = RequestBody.coupons(page: page, per_page: per_page, filer: filer)
        self.networkFetch(request: RequestFactory.request(requestBody: requestData))
    }
    
    override func parse(data: Data) {
        let jsonDecoder = JSONDecoder()
        do {
            let resultArray = try jsonDecoder.decode(Coupons.self, from: data)
            successHandler!(resultArray)
        } catch let jsonError {
            print("CouponsFetcher: Json Parsing Error: \(jsonError)")
            errorHandler(jsonError.localizedDescription)
        }
    }
}
