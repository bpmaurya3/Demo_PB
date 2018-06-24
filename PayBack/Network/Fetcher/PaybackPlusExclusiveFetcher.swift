//
//  PaybackPlusExclusiveFetcher.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 11/23/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

class PaybackPlusExclusiveFetcher: Fetcher {
    fileprivate var successHandler: ((PaybackPlusExclusive) -> Void)?
    
    func onSuccess(success: @escaping (PaybackPlusExclusive) -> Void) -> Self {
        self.successHandler = success
        
        return self
    }
    
    func fetchPaybackPlusExclusive() {
        self.networkFetch(request: RequestFactory.paybackPlusExclusive())
    }
    
    override func parse(data: Data) {
        let jsonDecoder = JSONDecoder()
        do {
            let exclusive = try jsonDecoder.decode(PaybackPlusExclusive.self, from: data)
            guard exclusive.errorCode == nil else {
                errorHandler(exclusive.errorMessage ?? "")
                return
            }
            successHandler!(exclusive)
        } catch let jsonError {
            print("PaybackPlusExclusiveFetcher: Json Parsing Error: \(jsonError)")
        }
    }
}
