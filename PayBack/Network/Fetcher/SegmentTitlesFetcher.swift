//
//  SegmentTitlesFetcher.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 10/30/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

final internal class SegmentTitlesFetcher: Fetcher {
    fileprivate var successHandler: ((OfferMenuItems) -> Void)?
    
    func onSuccess(success: @escaping (OfferMenuItems) -> Void) -> Self {
        self.successHandler = success
        
        return self
    }
    
    func fetchCouponsCategories() {
        let requestBody = RequestBody.couponsCategory()
        self.networkFetch(request: RequestFactory.request(requestBody: requestBody))
    }
    
    func fetchRechargeCategories() {
        let when = DispatchTime.now() + 0.05
        DispatchQueue.main.asyncAfter(deadline: when) { [weak self] in
            if let strongSelf = self {
                strongSelf.networkFetch(request: RequestFactory.rechargeCategories())
            }
        }
    }
    
    func fetchInstoreOffersCategories() {
        let when = DispatchTime.now() + 0.05
        DispatchQueue.main.asyncAfter(deadline: when) { [weak self] in
            if let strongSelf = self {
                strongSelf.networkFetch(request: RequestFactory.instoreOffersCategories())
            }
        }
    }
    func fetchOnlineOffersCategories() {
        let when = DispatchTime.now() + 0.05
        DispatchQueue.main.asyncAfter(deadline: when) { [weak self] in
            if let strongSelf = self {
                strongSelf.networkFetch(request: RequestFactory.onlineOffersCategories())
            }
        }
    }
    
    override func parse(data: Data) {        
        let jsonDecoder = JSONDecoder()
        do {
            let resultArray = try jsonDecoder.decode(OfferMenuItems.self, from: data)
            
            guard resultArray.errorCode == nil else {
                errorHandler( resultArray.errorMessage ?? "Something went wrong")
                return
            }
            successHandler!(resultArray)
        } catch let jsonError {
            print("SegmentTitlesFetcher: Json Parsing Error: \(jsonError)")
            errorHandler(jsonError.localizedDescription)
        }
    }
}
