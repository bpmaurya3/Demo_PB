//
//  PointCalculatorFetcher.swift
//  PayBack
//
//  Created by Mohsin Surani on 20/12/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

class PointCalculatorFetcher: Fetcher {
    fileprivate var successHandler: ((PointCalculator) -> Void)?
    
    func onSuccess(success: @escaping (PointCalculator) -> Void) -> Self {
        self.successHandler = success
        
        return self
    }
    
    func fetchPointCalculator() {
        self.networkFetch(request: RequestFactory.pointCalculator())
    }
    
    override func parse(data: Data) {
        let jsonDecoder = JSONDecoder()
        do {
            let exclusive = try jsonDecoder.decode(PointCalculator.self, from: data)
            successHandler!(exclusive)
        } catch let jsonError {
            print("PointCalculatorFetcher: Json Parsing Error: \(jsonError)")
        }
    }
}
