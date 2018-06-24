//
//  InsuranceTypesFetcher.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 11/2/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

final internal class InsuranceTypesFetcher: Fetcher {
    fileprivate var successHandler: ((InsuranceTypes) -> Void)?

    func onSuccess(success: @escaping (InsuranceTypes) -> Void) -> Self {
        self.successHandler = success
        
        return self
    }
    
    func fetchInsuranceTypes() {
        self.networkFetch(request: RequestFactory.insuranceTypes())
    }
    func fetchInsuranceSubTypes(tag: String) {
        self.networkFetch(request: RequestFactory.insuranceSubTypes(tag: tag))
    }
    
    override func parse(data: Data) {
        let jsonDecoder = JSONDecoder()
        do {
            let resultArray = try jsonDecoder.decode(InsuranceTypes.self, from: data)
            
            guard resultArray.errorCode == nil else {
                errorHandler(resultArray.errorMessage ?? "Something went wrong")
                return
            }
            successHandler!(resultArray)
        } catch let jsonError {
            print("InsuranceTypesFetcher: Json Parsing Error: \(jsonError)")
            errorHandler(jsonError.localizedDescription)
        }
    }
}
