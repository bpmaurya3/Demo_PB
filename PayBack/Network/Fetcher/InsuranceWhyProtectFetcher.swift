//
//  InsuranceWhyProtectFetcher.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 1/29/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import Foundation
final internal class InsuranceWhyProtectFetcher: Fetcher {
    fileprivate var successHandler: ((CouponsRecharge) -> Void)?
    
    func onSuccess(success: @escaping (CouponsRecharge) -> Void) -> Self {
        self.successHandler = success
        
        return self
    }
    
    func fetchWhyProtect() {
        self.networkFetch(request: RequestFactory.insuranceWhyProtect())
    }
    
    override func parse(data: Data) {
        let jsonDecoder = JSONDecoder()
        do {
            let resultArray = try jsonDecoder.decode(CouponsRecharge.self, from: data)
            
            guard resultArray.errorCode == nil else {
                errorHandler(resultArray.errorMessage ?? "Something went wrong")
                return
            }
            successHandler!(resultArray)
        } catch let jsonError {
            print("InsuranceWhyProtectFetcher: Json Parsing Error: \(jsonError)")
            errorHandler(jsonError.localizedDescription)
        }
    }
}
