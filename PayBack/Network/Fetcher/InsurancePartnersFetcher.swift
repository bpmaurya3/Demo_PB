//
//  InsurancePartnersFetcher.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 1/8/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import Foundation

final internal class InsurancePartnersFetcher: Fetcher {
    fileprivate var successHandler: ((OtherPartner) -> Void)?
    
    func onSuccess(success: @escaping (OtherPartner) -> Void) -> Self {
        self.successHandler = success
        
        return self
    }
    
    func fetchInsurancePartners() {
        self.networkFetch(request: RequestFactory.insurancePartners())
    }
    
    override func parse(data: Data) {
        let jsonDecoder = JSONDecoder()
        do {
            let resultArray = try jsonDecoder.decode(OtherPartner.self, from: data)
            
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
