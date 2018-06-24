//
//  CouponsRechargeFetcher.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 10/30/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

final internal class CouponsRechargeFetcher: Fetcher {
    fileprivate var successHandler: ((CouponsRecharge) -> Void)?
    
    func onSuccess(success: @escaping (CouponsRecharge) -> Void) -> Self {
        self.successHandler = success
        
        return self
    }
    
    func fetchCouponsDetails(tag: String) {
        self.networkFetch(request: RequestFactory.couponsDetails(tag: tag))
    }
    
    func fetchRechargeDetails(tag: String) {
        let when = DispatchTime.now() + 0.10
        DispatchQueue.main.asyncAfter(deadline: when) { [weak self] in
            if let strongSelf = self {
                strongSelf.networkFetch(request: RequestFactory.rechargeDetails(tag: tag))
            }
        }
    }
    
    func fetchInsuranceDetails(tag: String) {
        self.networkFetch(request: RequestFactory.insuranceDetails(tag: tag))
    }
    
    func fetchInstoreOffersDetails(tag: String) {
        self.networkFetch(request: RequestFactory.instoreOffersDetails(tag: tag))
    }
    
    func fetchOnlineOffersDetails(tag: String) {
        self.networkFetch(request: RequestFactory.onlineOffersDetails(tag: tag))
    }
    
    func fetchLandingOffers() {
        self.networkFetch(request: RequestFactory.landingOffers())
    }
    
    func fetchPaybackPlusPartners() {
        self.networkFetch(request: RequestFactory.paybackPlusPartners())
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
            print("CouponsRechargeFetcher: Json Parsing Error: \(jsonError)")
            errorHandler(jsonError.localizedDescription)
        }
    }
}
