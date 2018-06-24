//
//  OnlinePartnerFetcher.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 9/13/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

final internal class OnlinePartnerFetcher: Fetcher {
    
     fileprivate var successHandler: ((OtherPartner) -> Void)?
    
    func onSuccess(success: @escaping (OtherPartner) -> Void) -> Self {
        self.successHandler = success
        
        return self
    }
    func fetch(onlinePartnerFor type: OnlinePartnerType) {
        switch type {
        case .otherOnlinePartner:
            self.networkFetch(request: RequestFactory.otherOnlinePartnersForEarn())
        case .burnOnlinePartner:
            self.networkFetch(request: RequestFactory.onlinePartnersForBurn())
        case .earnPartner:
            self.networkFetch(request: RequestFactory.earnPartners())
        case .signupPartner:
            self.networkFetch(request: RequestFactory.signupPartners())
        case .bankingService:
            self.networkFetch(request: RequestFactory.bankingServicesPartners())
        case .carporateRewards:
            self.networkFetch(request: RequestFactory.corporateRewardsPartners())
        }
    }
    override func parse(data: Data) {
        
        var items: OtherPartner!
        
        let jsonDecoder = JSONDecoder()
        do {
            items = try jsonDecoder.decode(OtherPartner.self, from: data)
            guard items.errorCode == nil else {
                errorHandler(items.errorMessage ?? "")
                return
            }
            successHandler!(items)
        } catch let jsonError {
            print("OtherOnlinePartnerFetcher: Json Parsing Error: \(jsonError)")
        }
    }
}
